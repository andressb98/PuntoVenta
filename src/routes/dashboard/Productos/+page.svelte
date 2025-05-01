<script lang="ts">
    // Tipos
    type Producto = {
      id: number;
      nombre: string;
      codigo: string;
      precio: number;
      costo: number;
      cantidad: number;
      categoria: string;
      descripcion: string;
    };
  
    // Estado
    let productos: Producto[] = [
      {
        id: 1,
        nombre: "Laptop HP Pavilion",
        codigo: "LP-HP-001",
        precio: 1200,
        costo: 900,
        cantidad: 15,
        categoria: "Electrónicos",
        descripcion: "Laptop 15.6 pulgadas, 8GB RAM, 256GB SSD"
      },
      {
        id: 2,
        nombre: "Mouse Inalámbrico",
        codigo: "MS-LG-002",
        precio: 25,
        costo: 15,
        cantidad: 42,
        categoria: "Accesorios",
        descripcion: "Mouse ergonómico con conexión Bluetooth"
      },
      {
        id: 3,
        nombre: "Teclado Mecánico",
        codigo: "TK-RD-003",
        precio: 80,
        costo: 50,
        cantidad: 23,
        categoria: "Accesorios",
        descripcion: "Teclado mecánico con retroiluminación RGB"
      }
    ];
  
    let busqueda: string = "";
    let modalAgregarProducto = false;
    let modalMovimiento = false;
    let productoSeleccionado: Producto | null = null;
    let tipoMovimiento: "entrada" | "salida" = "entrada";
    let cantidadMovimiento = 0;
    let nuevoProducto: Omit<Producto, "id"> = {
      nombre: "",
      codigo: "",
      precio: 0,
      costo: 0,
      cantidad: 0,
      categoria: "",
      descripcion: ""
    };
  
    // Funciones
    function agregarProducto() {
      if (nuevoProducto.nombre && nuevoProducto.precio > 0) {
        const nuevoId = Math.max(...productos.map(p => p.id), 0) + 1;
        productos = [...productos, { id: nuevoId, ...nuevoProducto }];
        nuevoProducto = {
          nombre: "",
          codigo: "",
          precio: 0,
          costo: 0,
          cantidad: 0,
          categoria: "",
          descripcion: ""
        };
        modalAgregarProducto = false;
      }
    }
  
    function eliminarProducto(id: number) {
      productos = productos.filter(p => p.id !== id);
    }
  
    function prepararMovimiento(producto: Producto, tipo: "entrada" | "salida") {
      productoSeleccionado = producto;
      tipoMovimiento = tipo;
      cantidadMovimiento = 0;
      modalMovimiento = true;
    }
  
    function procesarMovimiento() {
      if (productoSeleccionado) {
        productos = productos.map(p => {
          if (p.id === productoSeleccionado?.id) {
            return {
              ...p,
              cantidad: tipoMovimiento === "entrada" 
                ? p.cantidad + cantidadMovimiento
                : Math.max(0, p.cantidad - cantidadMovimiento)
            };
          }
          return p;
        });
        modalMovimiento = false;
      }
    }
  
    // Filtrado
    $: productosFiltrados = productos.filter(p =>
      p.nombre.toLowerCase().includes(busqueda.toLowerCase()) ||
      p.codigo.toLowerCase().includes(busqueda.toLowerCase())
    );
  </script>
  
  <div class="container py-4">
    <h1 class="title is-2">Gestión de Productos</h1>
  
    <!-- Barra de búsqueda y acciones -->
    <div class="level">
      <div class="level-left">
        <div class="level-item">
          <div class="field has-addons">
            <div class="control">
              <input
                class="input"
                type="text"
                placeholder="Buscar productos..."
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
          <button class="button is-primary" onclick={() => modalAgregarProducto = true}>
            <span class="icon">
              <i class="fas fa-plus"></i>
            </span>
            <span>Nuevo Producto</span>
          </button>
        </div>
      </div>
    </div>
  
    <!-- Tabla de productos -->
    <div class="box">
      <div class="table-container">
        <table class="table is-fullwidth is-hoverable is-striped">
          <thead>
            <tr>
              <th>Código</th>
              <th>Nombre</th>
              <th>Precio</th>
              <th>Costo</th>
              <th>Stock</th>
              <th>Categoría</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            {#each productosFiltrados as producto (producto.id)}
              <tr>
                <td>{producto.codigo}</td>
                <td>
                  <p class="has-text-weight-bold">{producto.nombre}</p>
                  <p class="is-size-7 has-text-grey">{producto.descripcion}</p>
                </td>
                <td>${producto.precio.toFixed(2)}</td>
                <td>${producto.costo.toFixed(2)}</td>
                <td>
                  <span class="tag is-rounded {producto.cantidad <= 5 ? 'is-danger' : 'is-success'}">
                    {producto.cantidad}
                  </span>
                </td>
                <td>{producto.categoria}</td>
                <td>
                  <div class="buttons are-small">
                    <button class="button is-info is-light" onclick={() => {}}>
                      <span class="icon">
                        <i class="fas fa-edit"></i>
                      </span>
                    </button>
                    <button class="button is-danger is-light" onclick={() => eliminarProducto(producto.id)}>
                      <span class="icon">
                        <i class="fas fa-trash"></i>
                      </span>
                    </button>
                    <button class="button is-success is-light" onclick={() => prepararMovimiento(producto, 'entrada')}>
                      <span class="icon">
                        <i class="fas fa-arrow-down"></i>
                      </span>
                      <span>Entrada</span>
                    </button>
                    <button class="button is-warning is-light" onclick={() => prepararMovimiento(producto, 'salida')}>
                      <span class="icon">
                        <i class="fas fa-arrow-up"></i>
                      </span>
                      <span>Salida</span>
                    </button>
                  </div>
                </td>
              </tr>
            {/each}
          </tbody>
        </table>
      </div>
    </div>
  
    <!-- Modal para agregar producto -->
    <div class="modal" class:is-active={modalAgregarProducto}>
      <div class="modal-background" onclick={() => modalAgregarProducto = false}></div>
      <div class="modal-card">
        <header class="modal-card-head">
          <p class="modal-card-title">Agregar Nuevo Producto</p>
          <button class="delete" aria-label="close" onclick={() => modalAgregarProducto = false}></button>
        </header>
        <section class="modal-card-body">
          <div class="field">
            <label class="label">Nombre</label>
            <div class="control">
              <input class="input" type="text" placeholder="Nombre del producto" bind:value={nuevoProducto.nombre}>
            </div>
          </div>
          <div class="field">
            <label class="label">Código</label>
            <div class="control">
              <input class="input" type="text" placeholder="Código único" bind:value={nuevoProducto.codigo}>
            </div>
          </div>
          <div class="columns">
            <div class="column">
              <div class="field">
                <label class="label">Precio de Venta</label>
                <div class="control">
                  <input class="input" type="number" min="0" step="0.01" bind:value={nuevoProducto.precio}>
                </div>
              </div>
            </div>
            <div class="column">
              <div class="field">
                <label class="label">Costo</label>
                <div class="control">
                  <input class="input" type="number" min="0" step="0.01" bind:value={nuevoProducto.costo}>
                </div>
              </div>
            </div>
          </div>
          <div class="field">
            <label class="label">Cantidad Inicial</label>
            <div class="control">
              <input class="input" type="number" min="0" bind:value={nuevoProducto.cantidad}>
            </div>
          </div>
          <div class="field">
            <label class="label">Categoría</label>
            <div class="control">
              <input class="input" type="text" placeholder="Categoría" bind:value={nuevoProducto.categoria}>
            </div>
          </div>
          <div class="field">
            <label class="label">Descripción</label>
            <div class="control">
              <textarea class="textarea" placeholder="Descripción detallada" bind:value={nuevoProducto.descripcion}></textarea>
            </div>
          </div>
        </section>
        <footer class="modal-card-foot">
          <button class="button is-success" onclick={agregarProducto}>Guardar Producto</button>
          <button class="button" onclick={() => modalAgregarProducto = false}>Cancelar</button>
        </footer>
      </div>
    </div>
  
    <!-- Modal para movimientos de inventario -->
    <div class="modal" class:is-active={modalMovimiento}>
      <div class="modal-background" onclick={() => modalMovimiento = false}></div>
      <div class="modal-card">
        <header class="modal-card-head">
          <p class="modal-card-title">
            {tipoMovimiento === 'entrada' ? 'Entrada de Inventario' : 'Salida de Inventario'}
          </p>
          <button class="delete" aria-label="close" onclick={() => modalMovimiento = false}></button>
        </header>
        <section class="modal-card-body">
          {#if productoSeleccionado}
            <div class="content">
              <p><strong>Producto:</strong> {productoSeleccionado.nombre}</p>
              <p><strong>Código:</strong> {productoSeleccionado.codigo}</p>
              <p><strong>Stock actual:</strong> {productoSeleccionado.cantidad}</p>
              
              <div class="field">
                <label class="label">Cantidad a {tipoMovimiento === 'entrada' ? 'ingresar' : 'retirar'}</label>
                <div class="control">
                  <input 
                    class="input" 
                    type="number" 
                    min="1" 
                    bind:value={cantidadMovimiento}
                  >
                </div>
              </div>
              
              {#if tipoMovimiento === 'salida'}
                <div class="notification is-warning is-light">
                  <p>Verifica que tengas suficiente stock disponible antes de registrar la salida.</p>
                  <p>Stock después de la operación: {productoSeleccionado.cantidad - cantidadMovimiento}</p>
                </div>
              {/if}
            </div>
          {/if}
        </section>
        <footer class="modal-card-foot">
          <button class="button is-primary" onclick={procesarMovimiento}>
            Confirmar {tipoMovimiento === 'entrada' ? 'Entrada' : 'Salida'}
          </button>
          <button class="button" onclick={() => modalMovimiento = false}>Cancelar</button>
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