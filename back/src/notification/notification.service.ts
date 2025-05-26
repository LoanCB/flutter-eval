import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as nodemailer from 'nodemailer';
import { Reservation } from '../reservation/entities/reservation.entity';

@Injectable()
export class NotificationService {
  private readonly logger = new Logger(NotificationService.name);
  private readonly transporter: nodemailer.Transporter;

  constructor(private readonly configService: ConfigService) {
    // Configuration du transporteur email
    this.transporter = nodemailer.createTransport({
      host: this.configService.get('SMTP_HOST'),
      port: this.configService.get('SMTP_PORT'),
      secure: this.configService.get('SMTP_SECURE') === 'true',
      auth: {
        user: this.configService.get('SMTP_USER'),
        pass: this.configService.get('SMTP_PASSWORD'),
      },
    });
  }

  async sendReservationConfirmation(reservation: Reservation): Promise<void> {
    const { user, date, time, numberOfGuests, status } = reservation;

    // Envoi de l'email
    await this.sendEmail({
      to: user.email,
      subject: 'Confirmation de votre réservation',
      html: `
        <h1>Confirmation de réservation</h1>
        <p>Bonjour ${user.firstName},</p>
        <p>Votre réservation a été ${status === 'confirmed' ? 'confirmée' : 'enregistrée'}.</p>
        <p>Détails de la réservation :</p>
        <ul>
          <li>Date : ${date.toLocaleDateString()}</li>
          <li>Heure : ${time}</li>
          <li>Nombre de personnes : ${numberOfGuests}</li>
          <li>Statut : ${status === 'confirmed' ? 'Confirmée' : 'En attente'}</li>
        </ul>
        <p>Nous vous remercions de votre confiance.</p>
      `,
    });

    // Envoi d'une notification push (à implémenter selon votre système de push)
    await this.sendPushNotification({
      userId: user.id,
      title: 'Confirmation de réservation',
      body: `Votre réservation pour le ${date.toLocaleDateString()} à ${time} a été ${status === 'confirmed' ? 'confirmée' : 'enregistrée'}.`,
      data: {
        type: 'RESERVATION_CONFIRMATION',
        reservationId: reservation.id,
      },
    });
  }

  async sendReservationCancellation(reservation: Reservation): Promise<void> {
    const { user, date, time } = reservation;

    // Envoi de l'email
    await this.sendEmail({
      to: user.email,
      subject: 'Annulation de votre réservation',
      html: `
        <h1>Annulation de réservation</h1>
        <p>Bonjour ${user.firstName},</p>
        <p>Votre réservation a été annulée.</p>
        <p>Détails de la réservation annulée :</p>
        <ul>
          <li>Date : ${date.toLocaleDateString()}</li>
          <li>Heure : ${time}</li>
        </ul>
        <p>Nous espérons vous revoir bientôt.</p>
      `,
    });

    // Envoi d'une notification push
    await this.sendPushNotification({
      userId: user.id,
      title: 'Annulation de réservation',
      body: `Votre réservation pour le ${date.toLocaleDateString()} à ${time} a été annulée.`,
      data: {
        type: 'RESERVATION_CANCELLATION',
        reservationId: reservation.id,
      },
    });
  }

  async sendReservationReminder(reservation: Reservation): Promise<void> {
    const { user, date, time, numberOfGuests } = reservation;

    // Envoi de l'email
    await this.sendEmail({
      to: user.email,
      subject: 'Rappel de votre réservation',
      html: `
        <h1>Rappel de réservation</h1>
        <p>Bonjour ${user.firstName},</p>
        <p>Nous vous rappelons votre réservation pour demain :</p>
        <ul>
          <li>Date : ${date.toLocaleDateString()}</li>
          <li>Heure : ${time}</li>
          <li>Nombre de personnes : ${numberOfGuests}</li>
        </ul>
        <p>Nous vous remercions de votre confiance.</p>
      `,
    });

    // Envoi d'une notification push
    await this.sendPushNotification({
      userId: user.id,
      title: 'Rappel de réservation',
      body: `Rappel : Votre réservation pour demain à ${time} pour ${numberOfGuests} personne(s).`,
      data: {
        type: 'RESERVATION_REMINDER',
        reservationId: reservation.id,
      },
    });
  }

  private async sendEmail({
    to,
    subject,
    html,
  }: {
    to: string;
    subject: string;
    html: string;
  }): Promise<void> {
    try {
      await this.transporter.sendMail({
        from: this.configService.get('SMTP_FROM'),
        to,
        subject,
        html,
      });
      this.logger.log(`Email sent to ${to}`);
    } catch (error) {
      this.logger.error(`Failed to send email to ${to}:`, error);
      throw error;
    }
  }

  private async sendPushNotification({
    userId,
    title,
    body,
    data,
  }: {
    userId: number;
    title: string;
    body: string;
    data: Record<string, any>;
  }): Promise<void> {
    // TODO: Implémenter l'envoi de notification push
    // Cette implémentation dépendra de votre système de push (Firebase, OneSignal, etc.)
    this.logger.log(`Push notification sent to user ${userId}`);
  }
} 