import { PrismaClient } from '@prisma/client';
import { json } from '@sveltejs/kit';

const prisma = new PrismaClient();

export async function GET() {
  try {
    const usuarios = await prisma.usuario.findMany({
      select: {
        id: true,
        nombre: true,
        username: true,
        rol: true
      }
    });

    return json(usuarios);
  } catch (error) {
    console.error('Error al obtener usuarios:', error);
    return json({ error: 'Error al obtener usuarios' }, { status: 500 });
  }
}
