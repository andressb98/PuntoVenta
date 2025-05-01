<script lang="ts">
  // Tipos
  type ProductoVenta = {
    id: number;
    nombre: string;
    precio: number;
    cantidad: number;
  };

  type Venta = {
    id: number;
    fecha: string;
    cliente: string;
    productos: ProductoVenta[];
    subtotal: number;
    iva: number;
    total: number;
    estado: 'completada' | 'cancelada';
    metodoPago: string;
    emailCliente: string;
  };

  // Estado
  let ventas: Venta[] = [
    {
      id: 1,
      fecha: '2023-05-20 14:30',
      cliente: 'Juan Pérez',
      productos: [
        { id: 1, nombre: 'Laptop HP', precio: 12000, cantidad: 1 },
        { id: 2, nombre: 'Mouse inalámbrico', precio: 350, cantidad: 2 }
      ],
      subtotal: 12700,
      iva: 2032,
      total: 14732,
      estado: 'completada',
      metodoPago: 'Tarjeta crédito',
      emailCliente: 'juan.perez@example.com'
    },
    {
      id: 2,
      fecha: '2023-05-19 11:15',
      cliente: 'Empresa ABC',
      productos: [
        { id: 3, nombre: 'Teclado mecánico', precio: 800, cantidad: 5 },
        { id: 4, nombre: 'Monitor 24"', precio: 3500, cantidad: 3 }
      ],
      subtotal: 14500,
      iva: 2320,
      total: 16820,
      estado: 'completada',
      metodoPago: 'Transferencia',
      emailCliente: 'compras@empresaabc.com'
    }
  ];

  let busqueda: string = '';
  let ventaSeleccionada: Venta | null = null;
  let modalCancelar = false;
  let modalReenviar = false;
  let emailReenvio = '';

  // Funciones
  function cancelarVenta(id: number) {
    ventas = ventas.map(v => 
      v.id === id ? { ...v, estado: 'cancelada' } : v
    );
    modalCancelar = false;
  }

  function prepararCancelacion(venta: Venta) {
    ventaSeleccionada = venta;
    modalCancelar = true;
  }

  function prepararReenvio(venta: Venta) {
    ventaSeleccionada = venta;
    emailReenvio = venta.emailCliente;
    modalReenviar = true;
  }

  function reenviarTicket() {
    if (ventaSeleccionada && emailReenvio) {
      // Aquí iría la lógica para enviar el correo
      console.log(`Ticket reenviado a: ${emailReenvio}`);
      modalReenviar = false;
    }
  }

  function imprimirTicket(id: number) {
    // Lógica para imprimir el ticket
    console.log(`Imprimiendo ticket de venta ${id}`);
  }

  // Filtrado
  $: ventasFiltradas = ventas.filter(v =>
    v.cliente.toLowerCase().includes(busqueda.toLowerCase()) ||
    v.id.toString().includes(busqueda)
  );
</script>

<div class="container py-4">
  <h1 class="title is-2">Historial de Ventas</h1>

  <!-- Barra de búsqueda -->
  <div class="field has-addons mb-5">
    <div class="control is-expanded">
      <input
        class="input"
        type="text"
        placeholder="Buscar ventas por cliente o ID..."
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

  <!-- Tabla de ventas -->
  <div class="box">
    <div class="table-container">
      <table class="table is-fullwidth is-hoverable is-striped">
        <thead>
          <tr>
            <th>ID/Fecha</th>
            <th>Cliente</th>
            <th>Productos</th>
            <th>Total</th>
            <th>Estado</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          {#each ventasFiltradas as venta (venta.id)}
            <tr class="{venta.estado === 'cancelada' ? 'has-background-danger-light' : ''}">
              <td>
                <p class="has-text-weight-bold">#{venta.id}</p>
                <p class="is-size-7">{venta.fecha}</p>
              </td>
              <td>
                <p>{venta.cliente}</p>
                <p class="is-size-7 has-text-grey">{venta.emailCliente}</p>
              </td>
              <td>
                <div class="tags are-small">
                  {#each venta.productos as producto}
                    <span class="tag is-light">
                      {producto.nombre} x{producto.cantidad}
                    </span>
                  {/each}
                </div>
              </td>
              <td>
                <p class="has-text-weight-bold">${venta.total.toFixed(2)}</p>
                <p class="is-size-7">{venta.metodoPago}</p>
              </td>
              <td>
                <span class="tag {venta.estado === 'completada' ? 'is-success' : 'is-danger'}">
                  {venta.estado === 'completada' ? 'Completada' : 'Cancelada'}
                </span>
              </td>
              <td>
                <div class="buttons are-small">
                  <button 
                    class="button is-info is-light" 
                    onclick={() => prepararReenvio(venta)}
                    disabled={venta.estado === 'cancelada'}
                  >
                    <span class="icon">
                      <i class="fas fa-envelope"></i>
                    </span>
                    <span>Reenviar</span>
                  </button>
                  <button 
                    class="button is-primary is-light" 
                    onclick={() => imprimirTicket(venta.id)}
                  >
                    <span class="icon">
                      <i class="fas fa-print"></i>
                    </span>
                    <span>Imprimir</span>
                  </button>
                  <button 
                    class="button is-danger is-light" 
                    onclick={() => prepararCancelacion(venta)}
                    disabled={venta.estado === 'cancelada'}
                  >
                    <span class="icon">
                      <i class="fas fa-ban"></i>
                    </span>
                    <span>Cancelar</span>
                  </button>
                </div>
              </td>
            </tr>
          {/each}
        </tbody>
      </table>
    </div>
  </div>

  <!-- Modal para cancelar venta -->
  {#if ventaSeleccionada && modalCancelar}
    <div class="modal is-active">
      <div class="modal-background" onclick={() => modalCancelar = false}></div>
      <div class="modal-card">
        <header class="modal-card-head">
          <p class="modal-card-title">Confirmar Cancelación</p>
          <button class="delete" aria-label="close" onclick={() => modalCancelar = false}></button>
        </header>
        <section class="modal-card-body">
          <div class="content">
            <p>¿Estás seguro que deseas cancelar la venta <strong>#{ventaSeleccionada.id}</strong>?</p>
            <p><strong>Cliente:</strong> {ventaSeleccionada.cliente}</p>
            <p><strong>Total:</strong> ${ventaSeleccionada.total.toFixed(2)}</p>
            <p><strong>Productos:</strong></p>
            <ul>
              {#each ventaSeleccionada.productos as producto}
                <li>{producto.nombre} x{producto.cantidad} - ${producto.precio.toFixed(2)} c/u</li>
              {/each}
            </ul>
            <div class="notification is-warning">
              Esta acción no se puede deshacer. Se generará un registro de cancelación.
            </div>
          </div>
        </section>
        <footer class="modal-card-foot">
          <button class="button is-danger" onclick={() => cancelarVenta(ventaSeleccionada.id)}>
            Confirmar Cancelación
          </button>
          <button class="button" onclick={() => modalCancelar = false}>Cancelar</button>
        </footer>
      </div>
    </div>
  {/if}

  <!-- Modal para reenviar ticket -->
  {#if ventaSeleccionada && modalReenviar}
    <div class="modal is-active">
      <div class="modal-background" onclick={() => modalReenviar = false}></div>
      <div class="modal-card">
        <header class="modal-card-head">
          <p class="modal-card-title">Reenviar Ticket</p>
          <button class="delete" aria-label="close" onclick={() => modalReenviar = false}></button>
        </header>
        <section class="modal-card-body">
          <div class="content">
            <p>Venta <strong>#{ventaSeleccionada.id}</strong> a <strong>{ventaSeleccionada.cliente}</strong></p>
            <p class="mb-4">Total: <strong>${ventaSeleccionada.total.toFixed(2)}</strong></p>
            
            <div class="field">
              <label class="label">Correo electrónico de destino</label>
              <div class="control">
                <input 
                  class="input" 
                  type="email" 
                  placeholder="Correo electrónico" 
                  bind:value={emailReenvio}
                >
              </div>
            </div>
            
            <div class="notification is-info">
              Se enviará un correo con los detalles de la compra y el ticket en formato PDF.
            </div>
          </div>
        </section>
        <footer class="modal-card-foot">
          <button class="button is-success" onclick={reenviarTicket}>
            <span class="icon">
              <i class="fas fa-paper-plane"></i>
            </span>
            <span>Reenviar Ticket</span>
          </button>
          <button class="button" onclick={() => modalReenviar = false}>Cancelar</button>
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
    gap: 0.25rem;
  }
  
  .tags .tag {
    margin-bottom: 0;
  }
</style>