import { json } from '@sveltejs/kit';
import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

const prisma = new PrismaClient();
const JWT_SECRET = 'tu_secreto_jwt'; // Cambia esto por un secreto seguro y guárdalo en variables de entorno

export async function POST({ request }) {
  try {
    const { username, password } = await request.json(); // Cambiado de email a username

    // Validar que se proporcionaron ambos campos
    if (!username || !password) {
      return json({ message: 'Nombre de usuario y contraseña son requeridos' }, { status: 400 });
    }

    // Buscar usuario por nombre de usuario
    const usuario = await prisma.usuario.findUnique({
      where: { username } // Buscar por username en lugar de email
    });

    if (!usuario) {
      return json({ message: 'Nombre de usuario o contraseña incorrectos' }, { status: 401 });
    }

    // Verificar contraseña
    const passwordMatch = await bcrypt.compare(password, usuario.password);
    if (!passwordMatch) {
      return json({ message: 'Nombre de usuario o contraseña incorrectos' }, { status: 401 });
    }

    // Verificar si el usuario está activo
    if (!usuario.activo) {
      return json({ message: 'Tu cuenta está desactivada. Contacta al administrador.' }, { status: 403 });
    }

    // Crear token JWT
    const token = jwt.sign(
      { 
        id: usuario.id, 
        username: usuario.username, 
        rol: usuario.rol 
      },
      JWT_SECRET,
      { expiresIn: '1h' }
    );

    return json({
      message: 'Autenticación exitosa',
      token,
      user: {
        id: usuario.id,
        username: usuario.username,
        nombre: usuario.nombre,
        rol: usuario.rol,
        email: usuario.email
      }
    });

  } catch (error) {
    console.error('Error en login:', error);
    return json({ 
      message: 'Error en el servidor',
      error: process.env.NODE_ENV === 'development' ? error.message : undefined
    }, { status: 500 });
  }
}