import { PrismaClient } from '@prisma/client';
import { json } from '@sveltejs/kit';
import bcrypt from 'bcrypt';

const prisma = new PrismaClient();

export async function POST({ request }: { request: Request }) {
    const { email, password, nombre } = await request.json();

    // Validar datos
    if (!email || !password || !nombre) {
        return json({ error: 'Todos los campos son obligatorios.' }, { status: 400 });
    }

    // Verificar si el usuario ya existe
    const existingUser = await prisma.usuario.findUnique({
        where: { email }
    });

    if (existingUser) {
        return json({ error: 'El correo ya está registrado.' }, { status: 400 });
    }

    // Hashear la contraseña
    const hashedPassword = await bcrypt.hash(password, 10);

    // Crear el usuario
    const newUser = await prisma.usuario.create({
        data: {
            email,
            password: hashedPassword,
            nombre
        }
    });

    return json({ message: 'Usuario registrado exitosamente.', user: { id: newUser.id, email: newUser.email } });
}