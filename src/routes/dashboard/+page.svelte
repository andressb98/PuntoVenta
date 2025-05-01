<script lang="ts">
    // Datos simplificados para punto de venta
    let posData = {
      businessName: "Tienda Rápida 24/7",
      owner: "María González",
      todaySales: 42,
      totalSales: 1245,
      cashAvailable: 18500,
      lowStockItems: 3
    };
  
    let recentTransactions = [
      { id: 1001, amount: 245.50, time: "14:32", method: "Tarjeta" },
      { id: 1002, amount: 120.00, time: "12:15", method: "Efectivo" },
      { id: 1003, amount: 89.75,  time: "18:45", method: "Tarjeta" }
    ];
  
    let alerts = [
      { id: 1, message: "Stock bajo: Agua Mineral (3 unidades)", urgent: true },
      { id: 2, message: "Promoción activa: 2x1 en galletas", urgent: false }
    ];
  </script>
  
  <div class="container">
    <div class="columns">
      <!-- Columna izquierda - Resumen -->
      <div class="column is-4">
        <div class="box">
          <div class="media">
            <div class="media-left">
              <figure class="image is-64x64">
                <img src="/pos-avatar.jpg" alt="Perfil" class="is-rounded">
              </figure>
            </div>
            <div class="media-content">
              <p class="title is-4">{posData.owner}</p>
              <p class="subtitle is-6">{posData.businessName}</p>
            </div>
          </div>
  
          <hr>
  
          <div class="stats">
            <div class="stat">
              <p class="heading">Ventas Hoy</p>
              <p class="title is-3">{posData.todaySales}</p>
            </div>
            <div class="stat">
              <p class="heading">Ventas Totales</p>
              <p class="title is-3">{posData.totalSales}</p>
            </div>
          </div>
  
          <div class="notification is-info">
            <p class="title is-5">${posData.cashAvailable.toLocaleString()}</p>
            <p class="subtitle is-6">Efectivo disponible</p>
          </div>
        </div>
  
        <!-- Alertas de stock -->
        <div class="box">
          <h2 class="title is-5">Alertas ({posData.lowStockItems})</h2>
          {#each alerts as alert}
            <div class="notification {alert.urgent ? 'is-danger' : 'is-warning'}">
              <button class="delete"></button>
              {alert.message}
            </div>
          {/each}
        </div>
      </div>
  
      <!-- Columna derecha - Transacciones -->
      <div class="column is-8">
        <div class="box">
          <div class="level">
            <div class="level-left">
              <h2 class="title is-4">Últimas Transacciones</h2>
            </div>
            <div class="level-right">
              <button class="button is-link is-small">
                Ver historial completo
              </button>
            </div>
          </div>
  
          <table class="table is-fullwidth is-striped">
            <thead>
              <tr>
                <th>ID</th>
                <th>Hora</th>
                <th>Monto</th>
                <th>Método</th>
                <th>Acciones</th>
              </tr>
            </thead>
            <tbody>
              {#each recentTransactions as t}
                <tr>
                  <td>#{t.id}</td>
                  <td>{t.time}</td>
                  <td>${t.amount.toFixed(2)}</td>
                  <td>
                    <span class="tag {t.method === 'Tarjeta' ? 'is-info' : 'is-success'}">
                      {t.method}
                    </span>
                  </td>
                  <td>
                    <button class="button is-small is-info is-outlined">
                      Detalles
                    </button>
                  </td>
                </tr>
              {/each}
            </tbody>
          </table>
        </div>
  
        <!-- Panel rápido -->
        <div class="box">
          <h2 class="title is-4">Acciones Rápidas</h2>
          <div class="buttons">
            <button class="button is-primary is-medium">
              <span class="icon">
                <i class="fas fa-cash-register"></i>
              </span>
              <span>Nueva Venta</span>
            </button>
            <button class="button is-info is-medium">
              <span class="icon">
                <i class="fas fa-boxes"></i>
              </span>
              <span>Administrar Inventario</span>
            </button>
            <button class="button is-link is-medium">
              <span class="icon">
                <i class="fas fa-file-invoice-dollar"></i>
              </span>
              <span>Reportes</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
  
  <style>
    .stats {
      display: flex;
      justify-content: space-between;
      text-align: center;
      margin: 1.5rem 0;
    }
    
    .stat {
      flex: 1;
      padding: 0 0.5rem;
    }
    
    .notification {
      margin-bottom: 1rem;
    }
    
    .buttons {
      justify-content: center;
    }
    
    .buttons .button {
      margin: 0 0.5rem;
    }
  </style>