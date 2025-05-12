<script lang="ts">
	import { invalidate } from '$app/navigation';
	import { onMount } from 'svelte';

	// Tipos basados en tu modelo Prisma
	type Credito = {
		id?: number;
		id_cliente: number;
		credito_total: number;
		disponible: number;
		pagado: number;
		saldo: number;
		estatus: string;
	};

	type Cliente = {
		id?: number;
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
		credito?: Credito;
	};

	// Estado
	let clientes: Cliente[] = [];
	let busqueda: string = '';
	let modalCredito = false;
	let clienteSeleccionado: Cliente | null = null;
	let isLoading = false;
	let modalAgregarCliente = false;
	let nuevoCliente: Cliente = {
		nombre: '',
		domicilio: '',
		telefono: '',
		correo: '',
		fecha_alta: new Date().toISOString(),
		fecha_baja: null,
		fecha_nacimiento: '',
		comentarios: '',
		referencias: '',
		usa_credito: false,
		credito: {
			id_cliente: 0,
			credito_total: 0,
			disponible: 0,
			pagado: 0,
			saldo: 0,
			estatus: 'ACTIVO'
		}
	};

	function resetearFormulario() {
		nuevoCliente = {
			nombre: '',
			domicilio: '',
			telefono: '',
			correo: '',
			fecha_alta: new Date().toISOString(),
			fecha_baja: null,
			fecha_nacimiento: '',
			comentarios: '',
			referencias: '',
			usa_credito: false,
			credito: {
				id_cliente: 0,
				credito_total: 0,
				disponible: 0,
				pagado: 0,
				saldo: 0,
				estatus: 'ACTIVO'
			}
		};
	}

	// Cargar clientes al iniciar
	onMount(async () => {
		await cargarClientes();
	});

	function formatDate(dateStr: string): string {
		const date = new Date(dateStr);
		return date.toLocaleDateString(); // O tu formato preferido
	}

	// Función para cargar clientes desde el endpoint
	async function cargarClientes() {
		try {
			isLoading = true;
			const response = await fetch('/api/clientes');
			if (!response.ok) throw new Error('Error al cargar clientes');
			clientes = await response.json();
		} catch (error) {
			console.error('Error:', error);
		} finally {
			isLoading = false;
		}
	}

	// Función para agregar cliente
	async function agregarCliente() {
		// Validación básica
		if (
			!nuevoCliente.nombre ||
			!nuevoCliente.domicilio ||
			!nuevoCliente.telefono ||
			!nuevoCliente.correo ||
			!nuevoCliente.fecha_nacimiento
		) {
			alert('Por favor complete todos los campos obligatorios');
			return;
		}

		if (
			nuevoCliente.usa_credito &&
			(!nuevoCliente.credito?.credito_total || nuevoCliente.credito.credito_total <= 0)
		) {
			alert('El monto de crédito debe ser mayor a cero');
			return;
		}

		try {
			isLoading = true;
			const body = {
				...nuevoCliente,
				// Si no usa crédito, no enviar la información de crédito
				credito: nuevoCliente.usa_credito ? nuevoCliente.credito : undefined
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
				throw new Error(errorData.message || 'Error al crear cliente');
			}

			modalAgregarCliente = false;
			resetearFormulario();
			await cargarClientes(); // Recargar la lista de clientes
			invalidate('app:clientes'); // Invalidar caché si es necesario
		} catch (error) {
			console.error('Error:', error);
			alert(error.message || 'Error al crear cliente');
		} finally {
			isLoading = false;
		}
	}

	// Función para habilitar crédito
	function habilitarCredito(cliente: Cliente) {
		clienteSeleccionado = JSON.parse(JSON.stringify(cliente));
		clienteSeleccionado.usa_credito = true;
		clienteSeleccionado.credito = {
			id_cliente: cliente.id || 0,
			credito_total: 0,
			disponible: 0,
			pagado: 0,
			saldo: 0,
			estatus: 'ACTIVO'
		};
		modalCredito = true;
	}

	// Función para guardar crédito
	async function guardarCredito() {
		if (!clienteSeleccionado || !clienteSeleccionado.credito) return;

		if (clienteSeleccionado.credito.credito_total <= 0) {
			alert('El monto de crédito debe ser mayor a cero');
			return;
		}

		try {
			isLoading = true;
			const response = await fetch('/api/clientes/credito', {
				method: 'POST',
				headers: {
					'Content-Type': 'application/json'
				},
				body: JSON.stringify({
					id_cliente: clienteSeleccionado.id,
					...clienteSeleccionado.credito
				})
			});

			if (!response.ok) {
				const errorData = await response.json();
				throw new Error(errorData.message || 'Error al guardar crédito');
			}

			modalCredito = false;
			await cargarClientes(); // Recargar la lista de clientes
		} catch (error) {
			console.error('Error:', error);
			alert(error.message || 'Error al guardar crédito');
		} finally {
			isLoading = false;
		}
	}

	// Función para preparar la asignación de crédito
	function prepararAsignarCredito(cliente: Cliente) {
		clienteSeleccionado = JSON.parse(JSON.stringify(cliente));
		if (!clienteSeleccionado.credito) {
			clienteSeleccionado.credito = {
				id_cliente: cliente.id || 0,
				credito_total: 0,
				disponible: 0,
				pagado: 0,
				saldo: 0,
				estatus: 'ACTIVO'
			};
		}
		modalCredito = true;
	}

	$: clientesFiltrados = busqueda
		? clientes.filter(
				(c) =>
					c.nombre.toLowerCase().includes(busqueda.toLowerCase()) ||
					c.correo.toLowerCase().includes(busqueda.toLowerCase()) ||
					c.telefono.includes(busqueda)
			)
		: clientes;
</script>

<div class="container py-4">
	<h1 class="title is-2">Gestión de Clientes</h1>

	<!-- Barra de búsqueda y acciones -->
	<div class="level">
		<div class="level-left">
			<div class="level-item">
				<div class="field has-addons">
					<div class="control">
						<input
							class="input"
							type="text"
							placeholder="Buscar clientes..."
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
				<button class="button is-primary" onclick={() => (modalAgregarCliente = true)}>
					<span class="icon">
						<i class="fas fa-plus"></i>
					</span>
					<span>Nuevo Cliente</span>
				</button>
			</div>
		</div>
	</div>

	<!-- Tabla de clientes -->
	<div class="box">
		<div class="table-container">
			<table class="table is-fullwidth is-hoverable is-striped">
				<thead>
					<tr>
						<th>Nombre</th>
						<th>Contacto</th>
						<th>Información</th>
						<th>Crédito</th>
						<th>Acciones</th>
					</tr>
				</thead>
				<tbody>
					{#each clientesFiltrados as cliente (cliente.id)}
						<tr>
							<td>
								<p class="has-text-weight-bold">{cliente.nombre}</p>
								<p class="is-size-7 has-text-grey">{cliente.domicilio}</p>
							</td>
							<td>
								<p>{cliente.telefono}</p>
								<p class="is-size-7 has-text-grey">{cliente.correo}</p>
							</td>
							<td>
								<p class="is-size-7">Alta: {formatDate(cliente.fecha_alta)}</p>
								<p class="is-size-7">Ref: {cliente.referencias || 'N/A'}</p>
							</td>
							<td>
								{#if cliente.usa_credito && cliente.credito}
									<p>Disponible: ${cliente.credito.disponible.toFixed(2)}</p>
									<p class="is-size-7">Total: ${cliente.credito.credito_total.toFixed(2)}</p>
									<p class="is-size-7">Saldo: ${cliente.credito.saldo.toFixed(2)}</p>
								{:else if cliente.usa_credito}
									<button
										class="button is-small is-warning"
										onclick={() => prepararAsignarCredito(cliente)}
									>
										Configurar crédito
									</button>
								{:else}
									<p class="has-text-grey">Sin crédito</p>
								{/if}
							</td>
							<td>
								<div class="buttons are-small">
									<button class="button is-info is-light" onclick={() => editarCliente(cliente)}>
										<span class="icon">
											<i class="fas fa-edit"></i>
										</span>
										<span>Editar</span>
									</button>
									{#if cliente.usa_credito}
										<button
											class="button is-warning is-light"
											onclick={() => prepararAsignarCredito(cliente)}
										>
											<span class="icon">
												<i class="fas fa-credit-card"></i>
											</span>
											<span>Crédito</span>
										</button>
									{:else}
										<button
											class="button is-success is-light"
											onclick={() => habilitarCredito(cliente)}
										>
											<span class="icon">
												<i class="fas fa-plus-circle"></i>
											</span>
											<span>Agregar Crédito</span>
										</button>
									{/if}
								</div>
							</td>
						</tr>
					{/each}
				</tbody>
			</table>
		</div>
	</div>

	<!-- Modal para agregar cliente -->
	<div class="modal" class:is-active={modalAgregarCliente}>
		<div class="modal-background" onclick={() => (modalAgregarCliente = false)}></div>
		<div class="modal-card">
			<header class="modal-card-head">
				<p class="modal-card-title">Agregar Nuevo Cliente</p>
				<button class="delete" aria-label="close" onclick={() => (modalAgregarCliente = false)}
				></button>
			</header>
			<section class="modal-card-body">
				<div class="field">
					<label class="label">Nombre/Razón Social*</label>
					<div class="control">
						<input
							class="input"
							type="text"
							placeholder="Nombre completo"
							bind:value={nuevoCliente.nombre}
							required
						/>
					</div>
				</div>

				<div class="field">
					<label class="label">Domicilio*</label>
					<div class="control">
						<input
							class="input"
							type="text"
							placeholder="Dirección completa"
							bind:value={nuevoCliente.domicilio}
							required
						/>
					</div>
				</div>

				<div class="columns">
					<div class="column">
						<div class="field">
							<label class="label">Teléfono*</label>
							<div class="control">
								<input
									class="input"
									type="tel"
									placeholder="Teléfono"
									bind:value={nuevoCliente.telefono}
									required
								/>
							</div>
						</div>
					</div>
					<div class="column">
						<div class="field">
							<label class="label">Correo Electrónico*</label>
							<div class="control">
								<input
									class="input"
									type="email"
									placeholder="email@cliente.com"
									bind:value={nuevoCliente.correo}
									required
								/>
							</div>
						</div>
					</div>
				</div>

				<div class="columns">
					<div class="column">
						<div class="field">
							<label class="label">Fecha de Nacimiento*</label>
							<div class="control">
								<input
									class="input"
									type="date"
									bind:value={nuevoCliente.fecha_nacimiento}
									required
								/>
							</div>
						</div>
					</div>
					<div class="column">
						<div class="field">
							<label class="label">Referencias</label>
							<div class="control">
								<input
									class="input"
									type="text"
									placeholder="Cómo nos conoció"
									bind:value={nuevoCliente.referencias}
								/>
							</div>
						</div>
					</div>
				</div>

				<div class="field">
					<label class="label">Comentarios</label>
					<div class="control">
						<textarea
							class="textarea"
							placeholder="Notas adicionales"
							bind:value={nuevoCliente.comentarios}
						></textarea>
					</div>
				</div>

				<div class="field">
					<div class="control">
						<label class="checkbox">
							<input type="checkbox" bind:checked={nuevoCliente.usa_credito} />
							Habilitar crédito para este cliente
						</label>
					</div>
				</div>

				{#if nuevoCliente.usa_credito}
					<div class="field">
						<label class="label">Línea de Crédito</label>
						<div class="columns">
							<div class="column">
								<div class="field">
									<label class="label">Monto Total ($)*</label>
									<div class="control">
										<input
											class="input"
											type="number"
											min="0"
											step="0.01"
											bind:value={nuevoCliente.credito.credito_total}
											required
										/>
									</div>
								</div>
							</div>
							<div class="column">
								<div class="field">
									<label class="label">Estatus*</label>
									<div class="control">
										<div class="select is-fullwidth">
											<select bind:value={nuevoCliente.credito.estatus} required>
												<option value="ACTIVO">Activo</option>
												<option value="SUSPENDIDO">Suspendido</option>
												<option value="CANCELADO">Cancelado</option>
											</select>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="notification is-info is-light">
							<p>
								Al crear el crédito, el disponible será igual al monto total y el saldo inicial será
								0.
							</p>
						</div>
					</div>
				{/if}
			</section>
			<footer class="modal-card-foot">
				<button class="button is-success" onclick={agregarCliente}>Guardar Cliente</button>
				<button class="button" onclick={() => (modalAgregarCliente = false)}>Cancelar</button>
			</footer>
		</div>
	</div>

	<!-- Modal para asignar crédito -->
	{#if clienteSeleccionado}
		<div class="modal" class:is-active={modalCredito}>
			<div class="modal-background" onclick={() => (modalCredito = false)}></div>
			<div class="modal-card">
				<header class="modal-card-head">
					<p class="modal-card-title">
						{clienteSeleccionado.usa_credito ? 'Modificar' : 'Agregar'} Línea de Crédito
					</p>
					<button class="delete" aria-label="close" onclick={() => (modalCredito = false)}></button>
				</header>
				<section class="modal-card-body">
					<div class="content">
						<p><strong>Cliente:</strong> {clienteSeleccionado.nombre}</p>
						<p><strong>Teléfono:</strong> {clienteSeleccionado.telefono}</p>

						<div class="field">
							<label class="label">Monto Total de Crédito ($)*</label>
							<div class="control">
								<input
									class="input"
									type="number"
									min="0"
									step="0.01"
									bind:value={clienteSeleccionado.credito.credito_total}
									required
								/>
							</div>
						</div>

						<div class="field">
							<label class="label">Estatus*</label>
							<div class="control">
								<div class="select is-fullwidth">
									<select bind:value={clienteSeleccionado.credito.estatus} required>
										<option value="ACTIVO">Activo</option>
										<option value="SUSPENDIDO">Suspendido</option>
										<option value="CANCELADO">Cancelado</option>
									</select>
								</div>
							</div>
						</div>

						<div class="notification is-info is-light">
							{#if clienteSeleccionado.usa_credito && clienteSeleccionado.credito.disponible > 0}
								<p>
									Crédito disponible actual: ${clienteSeleccionado.credito.disponible.toFixed(2)}
								</p>
								<p>El nuevo monto total no afectará automáticamente el crédito disponible.</p>
							{:else}
								<p>Se establecerá el crédito disponible igual al monto total inicial.</p>
							{/if}
						</div>
					</div>
				</section>
				<footer class="modal-card-foot">
					<button class="button is-primary" onclick={guardarCredito}>
						{clienteSeleccionado.usa_credito ? 'Actualizar' : 'Guardar'} Crédito
					</button>
					<button class="button" onclick={() => (modalCredito = false)}>Cancelar</button>
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

	.tag {
		margin-bottom: 0;
	}
</style>