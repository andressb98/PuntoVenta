<script>
    import Sidebar from '../../components/Sidebar.svelte';
    import TopNav from '../../components/TopNav.svelte';
  </script>
  
  <div class="dashboard-layout">
    <TopNav />
    
    <div class="dashboard-main">
      <Sidebar />
      
      <main class="dashboard-content">
        <slot />
      </main>
    </div>
  </div>
  
  <style lang="postcss">
    :global(body) {
      margin: 0;
      padding: 0;
      min-height: 100vh;
      background-color: #f5f5f5;
    }
  
    .dashboard-layout {
      display: flex;
      flex-direction: column;
      min-height: 100vh;
    }
  
    .dashboard-main {
      display: flex;
      flex: 1;
    }
  
    .dashboard-content {
      flex: 1;
      padding: 2rem;
      background-color: #f5f5f5;
      overflow-y: auto;
      height: calc(100vh - 52px);
    }
  </style>