import { PrismaClient } from '@prisma/client';
import { json } from '@sveltejs/kit';

const prisma = new PrismaClient();

// GET: Obtener todos los almacenes
export async function GET() {
  try {
    console.log('🔍 Buscando almacenes...');

    const almacenes = await prisma.almacen.findMany({
      orderBy: {
        nombre: 'asc'
      },
      select: {
        id: true,
        nombre: true,
        ubicacion: true,
        createdAt: true,
        updatedAt: true,
      }
    });

    console.log('✅ Almacenes encontrados:', almacenes.length);
    return json(almacenes);
  } catch (error) {
    console.error('❌ Error al obtener almacenes:', error);
    return json(
      { error: 'Error al obtener los almacenes', detalle: error.message },
      { status: 500 }
    );
  }
}

// POST: Crear nuevo almacén
export async function POST({ request }) {
  try {
    const { nombre, ubicacion } = await request.json();

    if (!nombre || !ubicacion) {
      return json(
        { error: 'El nombre y ubicación del almacén son requeridos' }, 
        { status: 400 }
      );
    }

    const nuevoAlmacen = await prisma.almacen.create({
      data: {
        nombre,
        ubicacion
      },
      select: {
        id: true,
        nombre: true,
        ubicacion: true,
        createdAt: true,
        updatedAt: true
      }
    });

    console.log('➕ Almacén creado:', nuevoAlmacen);
    return json(nuevoAlmacen, { status: 201 });
  } catch (error) {
    console.error('Error al crear almacén:', error);

    if (error.code === 'P2002') {
      return json(
        { error: 'Ya existe un almacén con ese nombre' }, 
        { status: 400 }
      );
    }

    return json(
      { error: 'Error al crear el almacén', detalle: error.message }, 
      { status: 500 }
    );
  }
}

// DELETE: Eliminar almacén
export async function DELETE({ params }) {
  try {
    const { id } = params;

    console.log(`🗑️ Intentando eliminar almacén ID: ${id}`);
    
    // Verificar si el almacén existe
    const almacenExistente = await prisma.almacen.findUnique({
      where: { id: Number(id) }
    });

    if (!almacenExistente) {
      return json(
        { error: 'Almacén no encontrado' }, 
        { status: 404 }
      );
    }

    // Eliminar el almacén
    await prisma.almacen.delete({
      where: { id: Number(id) }
    });

    console.log(`✅ Almacén ID ${id} eliminado`);
    return json(
      { message: 'Almacén eliminado correctamente' }, 
      { status: 200 }
    );
  } catch (error) {
    console.error('Error al eliminar almacén:', error);

    if (error.code === 'P2003') {
      return json(
        { error: 'No se puede eliminar el almacén porque tiene registros asociados' }, 
        { status: 400 }
      );
    }

    return json(
      { error: 'Error al eliminar el almacén', detalle: error.message }, 
      { status: 500 }
    );
  }
}