import { PrismaClient } from '@prisma/client';
import { json } from '@sveltejs/kit';

const prisma = new PrismaClient();

// PUT: Actualizar almacén
export async function PUT({ params, request }) {
  try {
    const id = parseInt(params.id);
    const { nombre, responsableId } = await request.json();

    if (!nombre) {
      return json(
        { error: 'El nombre del almacén es requerido' },
        { status: 400 }
      );
    }

    const almacenActualizado = await prisma.almacen.update({
      where: { id },
      data: {
        nombre,
        responsable: responsableId ? { connect: { id: responsableId } } : undefined
      },
      include: {
        responsable: {
          select: {
            id: true,
            nombre: true
          }
        }
      }
    });

    return json(almacenActualizado);
  } catch (error) {
    console.error('Error al actualizar almacén:', error);
    
    if (error.code === 'P2025') {
      return json(
        { error: 'Almacén no encontrado' },
        { status: 404 }
      );
    }

    return json(
      { error: 'Error al actualizar el almacén' },
      { status: 500 }
    );
  }
}

// DELETE: Eliminar almacén
export async function DELETE({ params }) {
  try {
    const id = parseInt(params.id);

    await prisma.almacen.delete({
      where: { id }
    });

    return json(
      { message: 'Almacén eliminado correctamente' },
      { status: 200 }
    );
  } catch (error) {
    console.error('Error al eliminar almacén:', error);
    
    if (error.code === 'P2025') {
      return json(
        { error: 'Almacén no encontrado' },
        { status: 404 }
      );
    }

    return json(
      { error: 'Error al eliminar el almacén' },
      { status: 500 }
    );
  }
}