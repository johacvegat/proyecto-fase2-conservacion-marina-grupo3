import streamlit as st
import mysql.connector
import pandas as pd

# Configuración de la página
st.set_page_config(page_title="Gestión de Conservación Marina", layout="wide")

st.title("🌊 Sistema de Gestión - Conservación Marina")
st.sidebar.title("Menú de Navegación")
navegacion = st.sidebar.selectbox("Selecciona una opción", ["Dashboard General", "Consultar Vistas", "Registrar Visitante"])

# Función de conexión a MySQL
def conectar_db():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="navidad",  # Tu contraseña de MySQL
        database="db_conservacion_marina"
    )

# --- 1. DASHBOARD GENERAL ---
if navegacion == "Dashboard General":
    st.header("📊 Panel de Control y Métricas")
    
    try:
        db = conectar_db()
        
        # Consultar la vista de resumen de regiones
        query_regiones = "SELECT * FROM vw_resumen_regiones;"
        df_regiones = pd.read_sql(query_regiones, db)
        
        st.subheader("Resumen de Presupuesto y Centros por Región")
        st.dataframe(df_regiones, use_container_width=True)
        
        # Métrica rápida de total de presupuesto protegido
        total_presupuesto = df_regiones['presupuestoTotalCentros'].sum()
        st.metric(label="Presupuesto Total en Centros Marinos", value=f"${total_presupuesto:,.2f}")
        
        db.close()
    except Exception as e:
        st.error(f"Error al conectar con la base de datos: {e}")

# --- 2. CONSULTAR VISTAS ---
elif navegacion == "Consultar Vistas":
    st.header("🔍 Explorador de Vistas SQL")
    
    vista_seleccionada = st.selectbox(
        "Selecciona la vista que deseas consultar:",
        ["vw_resumen_regiones", "vw_estado_especies", "vw_actividades_centros", "vw_trabajadores_centros", "vw_participacion_visitantes", "vw_evaluacion_actividades"]
    )
    
    try:
        db = conectar_db()
        query = f"SELECT * FROM {vista_seleccionada};"
        df = pd.read_sql(query, db)
        st.success(f"Mostrando datos de: `{vista_seleccionada}`")
        st.dataframe(df, use_container_width=True)
        db.close()
    except Exception as e:
        st.error(f"Error al cargar la vista: {e}")

# --- 3. REGISTRAR VISITANTE (Formulario Transaccional) ---
elif navegacion == "Registrar Visitante":
    st.header("📝 Registro de Nuevo Visitante")
    
    with st.form("form_visitante"):
        id_visitante = st.text_input("ID Visitante (Ej: VIS100)")
        nombre_visitante = st.text_input("Nombre Completo")
        pais_origen = st.text_input("País de Origen")
        
        submitted = st.form_submit_button("Guardar Visitante")
        
        if submitted:
            if id_visitante and nombre_visitante:
                try:
                    db = conectar_db()
                    cursor = db.cursor()
                    # Usando el procedimiento almacenado que creamos en la Fase 5
                    cursor.callproc('sp_registrar_visitante', [id_visitante, nombre_visitante, pais_origen])
                    db.commit()
                    cursor.close()
                    db.close()
                    st.success(f"¡Visitante {nombre_visitante} registrado exitosamente!")
                except Exception as e:
                    st.error(f"Error al registrar: {e}")
            else:
                st.warning("Por favor completa al menos el ID y el Nombre.")