import smtplib
from email.mime.text import MIMEText
import sys

def enviar_correo(destinatario, asunto, cuerpo):
    remitente = "test@ejemplo.com"

    mensaje = MIMEText(cuerpo)
    mensaje['Subject'] = asunto
    mensaje['From'] = remitente
    mensaje['To'] = destinatario

    try:
        servidor = smtplib.SMTP("sandbox.smtp.mailtrap.io", 587)
        servidor.starttls()
        servidor.login("69aa978a06eb0d", "8245a8ae036b31")  # Credenciales de Mailtrap
        servidor.sendmail(remitente, destinatario, mensaje.as_string())
        servidor.quit()
        print("Correo enviado correctamente.")
    except Exception as e:
        print(f"Error al enviar el correo: {e}")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Uso: python3 sendmail.py <destinatario> <asunto> <cuerpo>")
        sys.exit(1)

    destinatario = sys.argv[1]
    asunto = sys.argv[2]
    cuerpo = sys.argv[3]

    enviar_correo(destinatario, asunto, cuerpo)

