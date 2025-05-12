<script lang="ts">
	import { onMount } from 'svelte';

	// Tipos
	type Cliente = {
		id: number;
		nombre: string;
		fecha_alta: string;
		fecha_baja: string | null;
		domicilio: string;
		correo: string;
		telefono: string;
		fecha_nacimiento: string;
		comentarios: string;
		referencias: string;
		usa_credito: boolean;
		credito?: {
			id: number;
			limite: number;
			disponible: number;
			dias_credito: number;
		};
	};

	// Estado
	let clientes: Cliente[] = [];
	let busqueda: string = '';
	let modalAgregarCliente = false;
	let modalCredito = false;
	let clienteSeleccionado: Cliente | null = null;
	let errorMessage = '';
	let isLoading = true;

	// Nuevo cliente inicial
	let nuevoCliente = {
		nombre: '',
		domicilio: '',
		telefono: '',
		correo: '',
		fecha_alta: new Date().toISOString().split('T')[0],
		fecha_baja: null,
		fecha_nacimiento: '',
		comentarios: '',
		referencias: '',
		usa_credito: false,
		credito: {
			limite: 0,
			dias_credito: 0,
			disponible: 0
		}
	};

	// Obtener datos al cargar el componente
	onMount(async () => {
		await cargarClientes();
	});

	async function cargarClientes() {
		isLoading = true;
		try {
			console.log('⏳ Cargando clientes...');

			const response = await fetch('/api/clientes');
			console.log('✅ Respuesta recibida:', response.status);

			if (!response.ok) {
				const errorData = await response.text();
				console.error('❌ Error en la respuesta:', errorData);
				throw new Error('Error al cargar clientes');
			}

			clientes = await response.json();
			console.log('👥 Clientes cargados:', clientes);
		} catch (error) {
			errorMessage = 'Error al cargar los clientes. Intenta nuevamente.';
			console.error('🔥 Error en cargarClientes:', error);
		} finally {
			isLoading = false;
		}
	}

	// Funciones CRUD
	async function agregarCliente() {
		if (!nuevoCliente.nombre || !nuevoCliente.telefono) {
			errorMessage = 'Nombre y teléfono son campos requeridos';
			return;
		}

		try {
			// Preparamos el cuerpo de la solicitud
			const body = {
				...nuevoCliente,
				// Solo enviamos crédito si está habilitado
				credito: nuevoCliente.usa_credito
					? {
							limite: nuevoCliente.credito.limite,
							dias_credito: nuevoCliente.credito.dias_credito
						}
					: undefined
			};

			const response = await fetch('/api/clientes', {
				method: 'POST',
				headers: {
					'Content-Type': 'application/json'
				},
				body: JSON.stringify(body)
			});

			if (!response.ok) {
				const errorData = await response.json();
				throw new Error(errorData.error || 'Error al crear cliente');
			}

			const clienteCreado = await response.json();
			clientes = [...clientes, clienteCreado];
			resetearFormulario();
			modalAgregarCliente = false;
		} catch (error) {
			errorMessage = error.message;
			console.error('Error al agregar cliente:', error);
		}
	}

	async function actualizarCredito() {
		if (!clienteSeleccionado) return;

		try {
			const response = await fetch(`/api/clientes/${clienteSeleccionado.id}/credito`, {
				method: 'PUT',
				headers: {
					'Content-Type': 'application/json'
				},
				body: JSON.stringify({
					limite: clienteSeleccionado.credito?.limite,
					dias_credito: clienteSeleccionado.credito?.dias_credito
				})
			});

			if (!response.ok) {
				const errorData = await response.json();
				throw new Error(errorData.error || 'Error al actualizar crédito');
			}

			// Actualizamos el estado local
			const creditoActualizado = await response.json();
			clientes = clientes.map((c) => {
				if (c.id === clienteSeleccionado.id) {
					return {
						...c,
						usa_credito: true,
						credito: creditoActualizado
					};
				}
				return c;
			});

			modalCredito = false;
			clienteSeleccionado = null;
		} catch (error) {
			errorMessage = error.message;
			console.error('Error al actualizar crédito:', error);
		}
	}

	async function habilitarCredito(cliente: Cliente) {
		clienteSeleccionado = JSON.parse(JSON.stringify(cliente));
		clienteSeleccionado.usa_credito = true;
		clienteSeleccionado.credito = {
			id: cliente.id,
			limite: 0,
			disponible: 0,
			dias_credito: 0
		};
		modalCredito = true;
	}

	async function toggleEstadoCliente(cliente: Cliente) {
		if (!confirm(`¿Estás seguro de ${cliente.activo ? 'desactivar' : 'activar'} este cliente?`))
			return;

		try {
			const response = await fetch(`/api/clientes/${cliente.id}/estado`, {
				method: 'PATCH',
				headers: {
					'Content-Type': 'application/json'
				},
				body: JSON.stringify({
					activo: !cliente.activo
				})
			});

			if (!response.ok) {
				const errorData = await response.json();
				throw new Error(errorData.error || 'Error al cambiar estado');
			}

			// Actualizamos el estado local
			clientes = clientes.map((c) => {
				if (c.id === cliente.id) {
					return {
						...c,
						activo: !c.activo
					};
				}
				return c;
			});
		} catch (error) {
			errorMessage = error.message;
			console.error('Error al cambiar estado:', error);
		}
	}

	function resetearFormulario() {
		nuevoCliente = {
			nombre: '',
			domicilio: '',
			telefono: '',
			correo: '',
			fecha_alta: new Date().toISOString().split('T')[0],
			fecha_baja: null,
			fecha_nacimiento: '',
			comentarios: '',
			referencias: '',
			usa_credito: false,
			credito: {
				limite: 0,
				dias_credito: 0,
				disponible: 0
			}
		};
		errorMessage = '';
	}

	// Filtrado
	$: clientesFiltrados = clientes.filter(
		(c) =>
			c.nombre.toLowerCase().includes(busqueda.toLowerCase()) ||
			(c.correo && c.correo.toLowerCase().includes(busqueda.toLowerCase())) ||
			(c.telefono && c.telefono.includes(busqueda))
	);
</script>

<div class="container py-4">
	<h1 class="title is-2">Gestión de Almacenes</h1>

	{#if errorMessage}
		<div class="notification is-danger is-light">
			<button class="delete" onclick={() => (errorMessage = '')}></button>
			{errorMessage}
		</div>
	{/if}

	<!-- Barra de búsqueda y acciones -->
	<div class="level">
		<div class="level-left">
			<div class="level-item">
				<div class="field has-addons">
					<div class="control">
						<input
							class="input"
							type="text"
							placeholder="Buscar almacenes..."
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
				<button
					class="button is-primary"
					onclick={() => (modalAgregarAlmacen = true)}
					disabled={isLoading}
				>
					<span class="icon">
						<i class="fas fa-plus"></i>
					</span>
					<span>Nuevo Almacén</span>
				</button>
			</div>
		</div>
	</div>

	<!-- Tabla de almacenes -->
	<div class="box">
		{#if isLoading}
			<div class="has-text-centered py-5">
				<span class="icon is-large">
					<i class="fas fa-spinner fa-pulse fa-3x"></i>
				</span>
				<p>Cargando almacenes...</p>
			</div>
		{:else}
			<div class="table-container">
				<table class="table is-fullwidth is-hoverable is-striped">
					<thead>
						<tr>
							<th>Nombre</th>
							<th>Ubicación</th>
							<th>Creado</th>
							<th>Actualizado</th>
							<th>Acciones</th>
						</tr>
					</thead>
					<tbody>
						{#each almacenesFiltrados as almacen (almacen.id)}
							<tr>
								<td class="has-text-weight-bold">{almacen.nombre}</td>
								<td>{almacen.ubicacion}</td>
								<td
									>{almacen.createdAt
										? new Date(almacen.createdAt).toLocaleDateString()
										: 'N/A'}</td
								>
								<td
									>{almacen.updatedAt
										? new Date(almacen.updatedAt).toLocaleDateString()
										: 'N/A'}</td
								>
								<td>
									<div class="buttons are-small">
										<button
											class="button is-danger is-light"
											onclick={() => eliminarAlmacen(almacen.id)}
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
		{/if}
	</div>

	<!-- Modal para agregar almacén -->
	<div class="modal" class:is-active={modalAgregarAlmacen}>
		<div class="modal-background" onclick={cerrarModal}></div>
		<div class="modal-card">
			<header class="modal-card-head">
				<p class="modal-card-title">Agregar Nuevo Almacén</p>
				<button class="delete" aria-label="close" onclick={cerrarModal}></button>
			</header>
			<section class="modal-card-body">
				<div class="field">
					<label class="label">Nombre del Almacén*</label>
					<div class="control">
						<input
							class="input"
							type="text"
							placeholder="Nombre identificador"
							bind:value={nuevoAlmacen.nombre}
							required
						/>
					</div>
				</div>

				<div class="field">
					<label class="label">Ubicación*</label>
					<div class="control">
						<input
							class="input"
							type="text"
							placeholder="Ubicación física"
							bind:value={nuevoAlmacen.ubicacion}
							required
						/>
					</div>
				</div>
			</section>
			<footer class="modal-card-foot">
				<button class="button is-success" onclick={agregarAlmacen}>Guardar Almacén</button>
				<button class="button" onclick={cerrarModal}>Cancelar</button>
			</footer>
		</div>
	</div>
</div>

<style>
	.table-container {
		max-height: 70vh;
		overflow-y: auto;
	}

	.buttons .button {
		margin-bottom: 0.25rem;
	}
</style>
