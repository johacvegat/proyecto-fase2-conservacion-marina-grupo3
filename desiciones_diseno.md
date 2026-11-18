# Decisiones de Diseño - Grupo 3 (Caso 3: Conservación Marina)

1. **Especialización de Especies:** 
   - Se implementará la jerarquía de la entidad `ESPECIE` contemplando sus subtipos (*pez*, *mamífero marino* y *coral*), asegurando que una especie clasificada pertenezca exclusivamente a una categoría y evitando redundancias de atributos[cite: 11].

2. **Identificación del Sector Marino:**
   - Dado que el `SECTOR_MARINO` es una entidad débil que depende de su `CENTRO` (identificado mediante un `numeroInterno` único solo dentro de su respectivo centro)[cite: 11], su clave primaria en el modelo relacional será compuesta (`codigoCentro`, `numeroInterno`).

3. **Control de Acceso y Roles:**
   - El atributo de roles del trabajador asociado a `CUENTA_USUARIO` se manejará de forma estructurada para permitir el control de permisos y accesos diferenciados requeridos por el sistema[cite: 11].

4. **Evaluaciones de Actividades:**
   - La entidad `EVALUACION` posee un identificador correlativo dependiente de la `ACTIVIDAD`, por lo que su clave primaria será compuesta (`idActividad`, `correlativo`), reflejando que no puede existir sin su respectiva actividad[cite: 6, 11].
