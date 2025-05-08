import { PrismaClient } from '@prisma/client';
import { json } from '@sveltejs/kit';
import bcrypt from 'bcrypt';

const prisma = new PrismaClient();

export async function POST({ request }) {  // Cambiado de GET a POST
    try {
        const { email, password, nombre } = await request.json();

        // Validación más robusta
        if (!email || !password || !nombre) {
            return json({ error: 'Todos los campos son obligatorios.' }, { status: 400 });
        }

        // Validar formato de email
        if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
            return json({ error: 'El formato del email es inválido.' }, { status: 400 });
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
                nombre,
                rol: 'usuario' // Asegúrate de incluir el rol
            }
        });

        return json({ 
            message: 'Usuario registrado exitosamente.', 
            user: { 
                id: newUser.id, 
                email: newUser.email,
                nombre: newUser.nombre
            } 
        }, { status: 201 });

    } catch (error) {
        console.error('Error en registro:', error);
        return json({ 
            error: 'Ocurrió un error al registrar el usuario.',
            details: error.message // En desarrollo puedes enviar detalles
        }, { status: 500 });
    }
}