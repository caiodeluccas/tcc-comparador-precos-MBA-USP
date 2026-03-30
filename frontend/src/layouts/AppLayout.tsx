import { Outlet } from "react-router";
import Footer from "../components/Footer";
import Navbar from "../components/Navbar";

function AppLayout() {
  return (
    <div className="app-shell">
      <Navbar />
      <main className="mx-auto max-w-7xl px-6 py-10">
        <Outlet />
      </main>
      <Footer />
    </div>
  );
}

export default AppLayout;
