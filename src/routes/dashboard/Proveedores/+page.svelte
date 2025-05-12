<script lang="ts">
    import { onMount } from 'svelte';

    // Tipos
    type Proveedor = {
        id: number;
        nombre: string;
        // Eliminamos rfc, direccion, telefono, email, activo de la definición del tipo
    };

    let proveedores: Proveedor[] = [];
    let busqueda: string = '';
    let modalAgregarProveedor = false;
    let modalEditarProveedor = false;
    let proveedorSeleccionado: Proveedor | null = null;
    let nuevoProveedor: { nombre: string } = {  // Solo necesitamos el nombre
        nombre: ''
    };
    let errorMensaje: string | null = null;

    // Cargar proveedores al iniciar
    async function cargarProveedores() {
        try {
            const response = await fetch('/api/proveedores');
            if (response.ok) {
                proveedores = await response.json();
            } else {
                console.error('Error al cargar proveedores');
            }
        } catch (error) {
            console.error('Error de red:', error);
        }
    }

    onMount(cargarProveedores);


    async function agregarProveedor() {
        errorMensaje = null;

        if (!nuevoProveedor.nombre) {
            errorMensaje = 'Nombre es un campo obligatorio';
            return;
        }

        try {
            const response = await fetch('/api/proveedores', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    nombre: nuevoProveedor.nombre, // Enviamos solo el nombre
                })
            });

            if (!response.ok) {
                const errorData = await response.json();
                errorMensaje = errorData.error || 'Error al agregar proveedor';
                return;
            }

            await cargarProveedores();
            resetearFormulario();
            modalAgregarProveedor = false;
        } catch (error) {
            console.error('Error de red:', error);
            errorMensaje = 'Error de conexión con el servidor';
        }
    }

    async function editarProveedor() {
        if (proveedorSeleccionado) {
            try {
                const response = await fetch(`/api/proveedores/${proveedorSeleccionado.id}`, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(proveedorSeleccionado) // Enviar el objeto completo para la actualización
                });

                if (response.ok) {
                    await cargarProveedores();
                    modalEditarProveedor = false;
                } else {
                    console.error('Error al editar proveedor');
                }
            } catch (error) {
                console.error('Error de red:', error);
            }
        }
    }

    async function eliminarProveedor(id: number) {
        try {
            const response = await fetch(`/api/proveedores/${id}`, {
                method: 'DELETE'
            });

            if (response.ok) {
                await cargarProveedores();
            } else {
                console.error('Error al eliminar proveedor');
            }
        } catch (error) {
            console.error('Error de red:', error);
        }
    }

    async function toggleEstadoProveedor(proveedor: Proveedor) {
        try {
            const response = await fetch(`/api/proveedores/${proveedor.id}`, {
                method: 'PATCH',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ activo: !proveedor.activo })
            });

            if (response.ok) {
                await cargarProveedores();
            } else {
                console.error('Error al cambiar estado del proveedor');
            }
        } catch (error) {
            console.error('Error de red:', error);
        }
    }

    function prepararEdicion(proveedor: Proveedor) {
        proveedorSeleccionado = JSON.parse(JSON.stringify(proveedor));
        modalEditarProveedor = true;
    }

    function resetearFormulario() {
        nuevoProveedor = {
            nombre: ''
        };
    }

    // Filtrado
    $: proveedoresFiltrados = proveedores.filter(
        (p) =>
            p.nombre.toLowerCase().includes(busqueda.toLowerCase())
    );
</script>

<div class="container py-4">
    <h1 class="title is-2">Gestión de Proveedores</h1>

    <div class="level">
        <div class="level-left">
            <div class="level-item">
                <div class="field has-addons">
                    <div class="control">
                        <input
                            class="input"
                            type="text"
                            placeholder="Buscar proveedores..."
                            bind:value={busqueda}
                        />
                    </div>
                    <div class="control">
                        <button class="button is-info">
                            <span class="icon">
                                <i class="fas fa-search"></i>
                            </span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <div class="level-right">
            <div class="level-item">
                <button class="button is-primary" onclick={() => (modalAgregarProveedor = true)}>
                    <span class="icon">
                        <i class="fas fa-plus"></i>
                    </span>
                    <span>Nuevo Proveedor</span>
                </button>
            </div>
        </div>
    </div>

    <div class="box">
        <div class="table-container">
            <table class="table is-fullwidth is-hoverable is-striped">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nombre</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    {#each proveedoresFiltrados as proveedor (proveedor.id)}
                        <tr>
                            <td>{proveedor.id}</td>
                            <td>
                                <p class="has-text-weight-bold">{proveedor.nombre}</p>
                            </td>
                            <td>
                                <div class="buttons are-small">
                                    <button
                                        class="button is-info is-light"
                                        onclick={() => prepararEdicion(proveedor)}
                                    >
                                        <span class="icon">
                                            <i class="fas fa-edit"></i>
                                        </span>
                                    </button>
                                    <button
                                        class="button is-danger is-light"
                                        onclick={() => eliminarProveedor(proveedor.id)}
                                    >
                                        <span class="icon">
                                            <i class="fas fa-trash"></i>
                                        </span>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    {/each}
                </tbody>
            </table>
        </div>
    </div>

    <div class="modal" class:is-active={modalAgregarProveedor}>
        <div class="modal-background" onclick={() => (modalAgregarProveedor = false)}></div>
        <div class="modal-card">
            <header class="modal-card-head">
                <p class="modal-card-title">Agregar Nuevo Proveedor</p>
                <button class="delete" aria-label="close" onclick={() => (modalAgregarProveedor = false)}
                ></button>
            </header>
            <section class="modal-card-body">
                <div class="field">
                    <label class="label">Nombre del Proveedor*</label>
                    <div class="control">
                        <input
                            class="input"
                            type="text"
                            placeholder="Nombre completo"
                            bind:value={nuevoProveedor.nombre}
                            required
                        />
                    </div>
                </div>
            </section>
            <footer class="modal-card-foot">
                <button class="button is-success" onclick={agregarProveedor}>Guardar Proveedor</button>
                <button class="button" onclick={() => (modalAgregarProveedor = false)}>Cancelar</button>
            </footer>
        </div>
    </div>

    {#if proveedorSeleccionado}
        <div class="modal" class:is-active={modalEditarProveedor}>
            <div class="modal-background" onclick={() => (modalEditarProveedor = false)}></div>
            <div class="modal-card">
                <header class="modal-card-head">
                    <p class="modal-card-title">Editar Proveedor</p>
                    <button class="delete" aria-label="close" onclick={() => (modalEditarProveedor = false)}
                    ></button>
                </header>
                <section class="modal-card-body">
                     <div class="field">
                        <label class="label">ID</label>
                        <div class="control">
                            <input class="input" type="text" bind:value={proveedorSeleccionado.id} readonly />
                        </div>
                    </div>
                    <div class="field">
                        <label class="label">Nombre del Proveedor*</label>
                        <div class="control">
                            <input class="input" type="text" bind:value={proveedorSeleccionado.nombre} required />
                        </div>
                    </div>
                </section>
                {#if errorMensaje}
                    <div class="notification is-danger is-light">
                        <button class="delete" onclick={() => (errorMensaje = null)}></button>
                        {errorMensaje}
                    </div>
                {/if}
                <footer class="modal-card-foot">
                    <button class="button is-success" onclick={editarProveedor}>Guardar Cambios</button>
                    <button class="button" onclick={() => (modalEditarProveedor = false)}>Cancelar</button>
                </footer>
            </div>
        </div>
    {/if}
</div>


<style>
	.table-container {
		max-height: 70vh;
		overflow-y: auto;
	}

	.buttons .button {
		margin-bottom: 0.25rem;
	}

	.tags {
		flex-wrap: wrap;
		gap: 0.5rem;
	}
</style>
