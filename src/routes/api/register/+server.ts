import { PrismaClient } from '@prisma/client';
import { json } from '@sveltejs/kit';
import bcrypt from 'bcrypt';

const prisma = new PrismaClient();

export async function POST({ request }) {
	try {
		const { username, password, id_rol } = await request.json();

		if (!username || !password || !id_rol) {
			return json({ error: 'Faltan campos obligatorios.' }, { status: 400 });
		}

		const existingUser = await prisma.usuario.findFirst({
			where: {
				OR: [{ nombre: username }]
			}
		});

		if (existingUser) {
			return json(
				{
					error:
						existingUser.nombre === username
							? 'El nombre de usuario ya está en uso.'
							: 'El correo electrónico ya está registrado.'
				},
				{ status: 400 }
			);
		}

		const hashedPassword = await bcrypt.hash(password, 10);

		const newUser = await prisma.usuario.create({
			data: {
				nombre: username,
				contraseña: hashedPassword,
				id_rol: Number(id_rol),
				activo: true
			}
		});

		return json({ message: 'Usuario registrado exitosamente.', user: newUser }, { status: 201 });
	} catch (error) {
		console.error('Error en registro:', error);
		return json(
			{
				error: 'Error al registrar usuario.',
				details: error.message // Add this line
			},
			{ status: 500 }
		);
	}
}
