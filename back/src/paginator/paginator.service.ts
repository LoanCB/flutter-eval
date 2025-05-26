import dayjs, { Dayjs } from 'dayjs';
import customParseFormat from 'dayjs/plugin/customParseFormat';
import {
  And,
  Between,
  Equal,
  FindManyOptions,
  FindOperator,
  In,
  LessThan,
  LessThanOrEqual,
  MoreThan,
  MoreThanOrEqual,
  Not,
  ObjectLiteral,
  Raw,
  SelectQueryBuilder,
} from 'typeorm';
import { PaginationParamsDto } from './paginator.dto';
import {
  EntityFilteredListOptions,
  FilterOp,
  ProcessedParams,
  RelationParam,
  SortOrder,
  SqlMultiFilterOptions,
} from './paginator.type';

dayjs.extend(customParseFormat);

// Query Builder
export * from './paginator.decorator';
export * from './paginator.dto';
export * from './paginator.type';

/**
 * Old way of building pagination and ordering using FindManyOptions object
 */
export const buildFindManyOptions = <Entity>(
  queryFilter: PaginationParamsDto,
  withDeleted = false,
): FindManyOptions<Entity> => {
  const { limit, offset, sortOrder, sortField } = queryFilter;

  const findManyOptions: FindManyOptions<Entity> = { withDeleted, order: {} };

  // Offset
  if (offset) {
    findManyOptions.skip = Number(offset);
  }

  // Limit
  if (limit) {
    findManyOptions.take = Number(limit);
  }

  // Sort and Order
  if (sortField) {
    findManyOptions.order![sortField] = sortOrder ?? 'asc';
  }

  return findManyOptions;
};

/**
 * Check if a string is a valid date and convert it if possible, or return the string
 */
const sanitizer = (value: string): string => {
  const date = dayjs(value, ['YYYY-MM-DDTHH:mm:ss.SSSZ', 'YYYY-MM-DD'], true);
  return date.isValid() && /^\d{4}-\d{2}-\d{2}.*/i.test(value) ? date.toString() : value;
};

/**
 * Convert semi-colon separated value into an array if not already and apply the sanitizer on each values
 */
const sanitizeQueryFilterValues = (filterValues: string | string[], separator = ';'): (string | Dayjs)[] => {
  if (!Array.isArray(filterValues)) {
    // Remove parenthesis and split by semi-colon
    filterValues = filterValues.slice(1, -1).split(separator);
  }

  return filterValues.map((filterVal) => sanitizer(filterVal));
};

const generateRandomSuffix = (): number => {
  return Math.floor(Math.random() * (99999 - 10000 + 1)) + 10000;
};

/**
 * Build the query filter to use on a QueryBuilder.where
 */
export const sqlBuildQueryFilter = (
  paginationParams: PaginationParamsDto,
  isAndCondition = false,
  options?: SqlMultiFilterOptions,
) => {
  const { filterField, filterOp, filter } = paginationParams;
  const filterSeparator = options?.filterSeparator ?? ',';
  const valueSeparator = filterSeparator === ',' ? ';' : ',';

  // Early return if one parameter is missing
  if (!filterField || !filterOp || !filter) {
    return [];
  }

  const orFilter: Record<string, string>[] = [];
  const andFilter = {};
  const processedParams: ProcessedParams = {
    filterField: filterField.split(filterSeparator),
    filterOp: filterOp.split(filterSeparator).map((filter) => filter.trim() as FilterOp),
    filter: filter ? filter.split(filterSeparator) : [''], // TODO fix this in the length verification instead of here (empty doesn't need filter value)
  };

  if (processedParams.filterField.length) {
    if (
      ![processedParams.filterOp, processedParams.filter].every(
        ({ length }) => length === processedParams.filterField.length,
      )
    ) {
      throw new Error('Params "filterField", "filterOp" and "filter" must have the same length');
    }

    const separators = {
      [FilterOp.BETWEEN]: valueSeparator,
      [FilterOp.IS_ANY_OF]: valueSeparator,
    };

    for (let i = 0; i < processedParams.filterField.length; i++) {
      const rawField = processedParams.filterField[i];
      const filterOnJoinTable = options?.filterOnJoinTable?.find((f) => f.field === rawField);
      const field = options?.filterOnJoinTable
        ? `${filterOnJoinTable?.tableAlias ?? options.mainTableAlias}.${filterOnJoinTable?.fieldAlias ?? rawField}`
        : rawField;
      const operator = processedParams.filterOp[i];
      const value = processedParams.filter[i];

      if (operator === FilterOp.IS_ANY_OF) {
        const isAnyOfRegexTerm = `^\\([^${separators[FilterOp.IS_ANY_OF]}]+(${separators[FilterOp.IS_ANY_OF]}[^${
          separators[FilterOp.IS_ANY_OF]
        }]+)*\\)$`;
        const isAnyOfRegex = new RegExp(isAnyOfRegexTerm);
        if (!isAnyOfRegex.test(value)) {
          throw new Error(
            `Incompatible value ${value}. ` +
              `Example of correct filter : (value1${separators[operator]}value2${separators[operator]}value3)`,
          );
        }
      } else if (operator === FilterOp.BETWEEN) {
        const betweenRegexTerm = `^[^${separators[FilterOp.BETWEEN]}]*${separators[FilterOp.BETWEEN]}[^${
          separators[FilterOp.BETWEEN]
        }]*$`;
        const betweenRegex = new RegExp(betweenRegexTerm);
        if (!betweenRegex.test(value)) {
          throw new Error(
            `Incompatible value ${value}. Exemple of correct filter : (value1${separators[operator]}value2)`,
          );
        }
      }

      const sanitizedValue = sanitizer(value);
      const response = {};
      const placeholder = `value_${i}`;
      const filterPlaceholder = `filter_${i}`;

      switch (operator) {
        case FilterOp.NOT:
          response[field] = Not(sanitizedValue);
          break;
        case FilterOp.EQUALS:
        case FilterOp.IS:
          response[field] = Equal(sanitizedValue);
          break;
        case FilterOp.STARTS_WITH:
          response[field] = Raw((alias) => `CAST(${alias} as varchar) ILike :${placeholder}`, {
            [placeholder]: `${sanitizedValue}%`,
          });
          break;
        case FilterOp.ENDS_WITH:
          response[field] = Raw((alias) => `CAST(${alias} as varchar) ILike :${placeholder}`, {
            [placeholder]: `%${sanitizedValue}`,
          });
          break;
        case FilterOp.IS_EMPTY:
          response[field] = Raw((alias) => `CAST(${alias} as varchar) ILike ''`);
          break;
        case FilterOp.IS_NOT_EMPTY:
          response[field] = Not(Raw((alias) => `CAST(${alias} as varchar) ILike ''`));
          break;
        case FilterOp.AFTER:
          response[field] = MoreThan(sanitizedValue);
          break;
        case FilterOp.BEFORE:
          response[field] = LessThan(sanitizedValue);
          break;
        case FilterOp.ON_OR_AFTER:
          response[field] = MoreThanOrEqual(sanitizedValue);
          break;
        case FilterOp.ON_OR_BEFORE:
          response[field] = LessThanOrEqual(sanitizedValue);
          break;
        case FilterOp.IS_ANY_OF:
          // Special treatment for split values
          response[field] = In(sanitizeQueryFilterValues(value, valueSeparator));
          break;
        case FilterOp.BETWEEN: {
          const [rangeGte, rangeLte] = sanitizeQueryFilterValues(value, valueSeparator);
          response[field] = Between(rangeGte, rangeLte);
          break;
        }
        case FilterOp.CONTAINS:
        default: {
          const splittedField = field.split('..');
          const isJSONBQuery = splittedField.length > 1;
          const key = splittedField.length > 1 ? splittedField[0] : field;
          response[key] = isJSONBQuery
            ? Raw((alias) => `(${alias} ->> :${filterPlaceholder}) ILike :${placeholder}`, {
                [filterPlaceholder]: splittedField[1],
                [placeholder]: `%${sanitizedValue}%`,
              })
            : Raw((alias) => `CAST(${alias} as varchar) ILike :${placeholder}`, {
                [placeholder]: `%${sanitizedValue}%`,
              });
          break;
        }
      }

      if (isAndCondition) {
        const splittedField = field.split('..');
        const key = splittedField.length > 1 ? splittedField[0] : field;
        andFilter[key] = andFilter[key] ? And(andFilter[key], response[key]) : response[key]; // TODO use array instead of object for andFilter
      } else {
        orFilter.push(response);
      }
    }
  } else {
    return [];
  }

  return isAndCondition ? andFilter : orFilter;
};

/**
 * Build the search filter array to use on a QueryBuilder.where
 */
export const sqlBuildSearchFilter = (searchValue: string, fields: string[]) => {
  const searchFilter: Record<string, FindOperator<string>>[] = [];
  for (const field of fields) {
    const placeHolder = `value_${field.replace(/\./, '_')}_${generateRandomSuffix()}`;
    searchFilter.push({
      [field]: Raw((alias) => `CAST(${alias} as varchar) ILike :${placeHolder}`, { [placeHolder]: `%${searchValue}%` }),
    });
  }
  return searchFilter;
};

/**
 * Recursive function to add on query the left join in order to load nested relations
 */
const loadLeftJoinAndSelect = <Entity extends ObjectLiteral>(
  query: SelectQueryBuilder<Entity>,
  alias: string,
  relationParam: RelationParam,
) => {
  // Apply left join on query
  query.leftJoinAndSelect(`${alias}.${relationParam.relation}`, relationParam.alias);

  // Recursive call on joins if defined
  if (relationParam.joins?.length) {
    for (const childRelation of relationParam.joins) {
      loadLeftJoinAndSelect(query, relationParam.alias, childRelation);
    }
  }
};

/**
 * Util function to paginate, order, search and filter on a given Repository.
 */
export const getEntityFilteredList = async <Entity extends ObjectLiteral>(
  options: EntityFilteredListOptions<Entity>,
): Promise<[Entity[], number]> => {
  const alias = options.repository.metadata.tableName;

  const { search } = options.queryFilter;
  const searchFilter = search && options.searchFields ? sqlBuildSearchFilter(search, options.searchFields) : [];

  // Default primary key name is `id`
  const pk = options.pkName ?? 'id';
  const orderField = `${alias}.${options.queryFilter.sortField ?? pk}`;
  const orderDirection = options.queryFilter.sortOrder === SortOrder.DESC ? 'DESC' : 'ASC';

  const rootQuery = options.repository.createQueryBuilder(alias).where(searchFilter);

  if (options.withDeleted) {
    rootQuery.withDeleted();
  }

  if (options.relations?.length) {
    for (const relationParam of options.relations) {
      loadLeftJoinAndSelect(rootQuery, alias, relationParam);
    }
  }

  const multipleFilter = sqlBuildQueryFilter(
    options.queryFilter,
    options.isAndCondition ?? true,
    options.filterOptions ? { filterOnJoinTable: options.filterOptions, mainTableAlias: alias } : undefined,
  );

  console.log(rootQuery.getSql());
  console.log(multipleFilter);

  rootQuery
    .andWhere(multipleFilter)
    .orderBy(orderField, orderDirection)
    .limit(options.queryFilter.limit)
    .offset(options.queryFilter.offset);

  return await rootQuery.getManyAndCount();
};
