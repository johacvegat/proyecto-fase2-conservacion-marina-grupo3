-- Creación de la base de datos para el Caso 3
DROP DATABASE IF EXISTS db_conservacion_marina;
CREATE DATABASE db_conservacion_marina;
USE db_conservacion_marina;

-- 1. Región Marítima
CREATE TABLE region (
    codigoRegion VARCHAR(10) PRIMARY KEY,
    nombreOficial VARCHAR(100) NOT NULL,
    superficieProtegida DECIMAL(10,2),
    presupuestoAnual DECIMAL(12,2),
    nivelProteccion VARCHAR(50)
);

-- 2. Centro de Conservación
CREATE TABLE centro (
    codigoCentro VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    fechaCreacion DATE,
    superficieProtegida DECIMAL(10,2),
    ubicacion VARCHAR(150),
    presupuesto DECIMAL(12,2),
    capacidadOperativa INT,
    estadoConservacion VARCHAR(50),
    codigoRegion VARCHAR(10) NOT NULL,
    CONSTRAINT fk_centro_region FOREIGN KEY (codigoRegion) REFERENCES region(codigoRegion)
);

-- 3. Sector Marino (Entidad débil dependiente de centro)
CREATE TABLE sector_marino (
    codigoCentro VARCHAR(10),
    numeroInterno INT,
    nombre VARCHAR(100) NOT NULL,
    extension DECIMAL(10,2),
    profundidadPromedio DECIMAL(8,2),
    temperatura DECIMAL(5,2),
    nivelAcceso VARCHAR(50),
    biodiversidad TEXT,
    PRIMARY KEY (codigoCentro, numeroInterno),
    CONSTRAINT fk_sector_centro FOREIGN KEY (codigoCentro) REFERENCES centro(codigoCentro)
);

-- 4. Especie Marina
CREATE TABLE especie (
    codigoEspecie VARCHAR(10) PRIMARY KEY,
    nombreCientifico VARCHAR(100) NOT NULL,
    nombreComun VARCHAR(100),
    estadoConservacion VARCHAR(50),
    fechaIncorporacion DATE,
    distribucionGeografica TEXT,
    tipoEspecie ENUM('Pez', 'Mamifero marino', 'Coral', 'No clasificada') DEFAULT 'No clasificada'
);

-- 5. Monitoreo (Entidad asociativa Sector - Especie)
CREATE TABLE monitoreo (
    idMonitoreo INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL,
    cantidadObservada INT,
    condicionesAmbientales VARCHAR(150),
    observaciones TEXT,
    codigoCentro VARCHAR(10) NOT NULL,
    numeroInterno INT NOT NULL,
    codigoEspecie VARCHAR(10) NOT NULL,
    CONSTRAINT fk_monitoreo_sector FOREIGN KEY (codigoCentro, numeroInterno) REFERENCES sector_marino(codigoCentro, numeroInterno),
    CONSTRAINT fk_monitoreo_especie FOREIGN KEY (codigoEspecie) REFERENCES especie(codigoEspecie)
);

-- 6. Actividad (Educativa / Recorrido)
CREATE TABLE actividad (
    idActividad VARCHAR(10) PRIMARY KEY,
    tipoActividad VARCHAR(50),
    fechaActividad DATETIME NOT NULL,
    codigoCentro VARCHAR(10) NOT NULL,
    numeroInterno INT NOT NULL,
    CONSTRAINT fk_actividad_sector FOREIGN KEY (codigoCentro, numeroInterno) REFERENCES sector_marino(codigoCentro, numeroInterno)
);

-- 7. Visitante
CREATE TABLE visitante (
    idVisitante VARCHAR(10) PRIMARY KEY,
    nombreVisitante VARCHAR(100) NOT NULL
);

-- 8. Participa (Relación N:M Actividad - Visitante)
CREATE TABLE participa (
    idActividad VARCHAR(10),
    idVisitante VARCHAR(10),
    asistio BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (idActividad, idVisitante),
    CONSTRAINT fk_participa_actividad FOREIGN KEY (idActividad) REFERENCES actividad(idActividad),
    CONSTRAINT fk_participa_visitante FOREIGN KEY (idVisitante) REFERENCES visitante(idVisitante)
);

-- 9. Evaluación (Entidad débil dependiente de Actividad)
CREATE TABLE evaluacion (
    idActividad VARCHAR(10),
    correlativo INT,
    calificacion INT CHECK (calificacion BETWEEN 1 AND 5),
    fecha DATE,
    comentario TEXT,
    PRIMARY KEY (idActividad, correlativo),
    CONSTRAINT fk_evaluacion_actividad FOREIGN KEY (idActividad) REFERENCES actividad(idActividad)
);

-- 10. Trabajador
CREATE TABLE trabajador (
    rutTrabajador VARCHAR(12) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cargo VARCHAR(50),
    presupuesto DECIMAL(10,2),
    codigoCentro VARCHAR(10) NOT NULL,
    CONSTRAINT fk_trabajador_centro FOREIGN KEY (codigoCentro) REFERENCES centro(codigoCentro)
);

-- 11. Cuenta Usuario (Seguridad y Roles)
CREATE TABLE cuenta_usuario (
    idCuenta VARCHAR(10) PRIMARY KEY,
    roles VARCHAR(100) NOT NULL,
    rutTrabajador VARCHAR(12) NOT NULL UNIQUE,
    CONSTRAINT fk_cuenta_trabajador FOREIGN KEY (rutTrabajador) REFERENCES trabajador(rutTrabajador)
);
