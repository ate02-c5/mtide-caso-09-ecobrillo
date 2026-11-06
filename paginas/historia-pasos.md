# Cómo se construyó la historia

La portada cuenta el destino: revisar 8707GBG antes del 26 de junio. Aquí queda el viaje: cómo
pasamos de «el parte y el contador no hablan el mismo idioma» a una decisión con fecha.

## Paso 1 · De tema a decisión

| | |
|---|---|
| **Tema** | El parte de agua de la flota: lo que declaran las furgonetas no cuadra con lo que mide el contador. |
| **Pregunta** | ¿Hay alguna furgoneta cuyo agua declarada contradiga lo que mide su contador, y qué hay que hacer con ella? |
| **Decisión** | Inspección de 8707GBG (fuga física y calibración del sensor: la deciden el jefe de taller y Operaciones) y auditoría del parte de mayo. Para el 26 de junio de 2026; la consecuencia es el coste de la revisión y, si es fuga real, el recargo del consumo no facturado. |

La prueba: después de leer la portada, el jefe de taller pide cita esta semana y Operaciones
tiene la auditoría en su calendario — si nadie hace nada distinto, la portada sigue siendo una tabla.

## Paso 2 · Qué se mueve en los datos

### 2a · El terreno

```cifras
{{ stg_parte.filas }} | servicios del parte (06/04 – 15/05/2026)
{{ stg_eventos.filas }} | eventos del contador registrados el lunes 18/05/2026
{{ historia_diaria.servicios[2] }} | servicios de un día normal del periodo (12/05/2026)
```
Lo que no sabemos todavía es «¿por qué?»: puede ser fuga física en el camión, o un sensor mal
calibrado. Con los datos de hoy, el mapa de calor del 2c y el cruce con operarios permiten
descartar explicaciones; la causa física final solo la puede confirmar un mecánico.

El gráfico de línea:
```grafico
tipo: linea
titular: Litros por servicio, día a día según el parte: un negocio parejo
modelo: historia_diaria
x: fecha
y: l_por_servicio
```

Y el histograma: el parte declara la mayoría de servicios entre 10 y 35 litros, con media
cercana a 19 — nada apunta a cobrar de más ni de menos de forma estructural en el global.

```grafico
tipo: histograma
titular: Cómo se reparten los litros por servicio de todo el parte
modelo: fact_servicios
columna: litros_agua
tramo: 5
marcas: media, mediana
```

¿Destaca algo a simple vista? En el terreno, no: día a día y servicio a servicio la flota
es estable. El exceso está en otra capa: no en cuántos litros declara cada servicio, sino
en *qué furgoneta* — cuando el dato se divide por lo que corresponde (el día del contador),
es ahí donde algo salta.

### 2b · El disparador

El mismo dato dividido por lo que corresponde: litros por servicio según el contador del
18/05, furgoneta a furgoneta.

```grafico
titular: El día del contador: 8707GBG salta un {{ historia_puente.hueco_pct[0] }} % por encima de su parte
modelo: historia_puente
barras: furgoneta → l_por_servicio_contador
destacar: 8707GBG
referencia: {{ historia_puente.l_por_servicio_parte[0] }} · lo que declara su parte
orden: desc
```

**El hallazgo en una frase:** el contador mide
{{ historia_puente.l_por_servicio_contador[0] }} l/servicio en 8707GBG frente a los
{{ historia_puente.l_por_servicio_parte[0] }} que declara la propia furgoneta en el parte —
un hueco de {{ historia_puente.hueco_pct[0] }} % cuando el resto de la flota está en la banda
−16,5 % / +7,3 %. ¿El motivo? Como hipótesis: fuga física en el camión o un sensor mal calibrado.
Qué la sustenta a la espera de confirmar (se testea en el 2c): el patrón se repite en la
furgoneta sea quien sea el lavador y el tipo de turno.

### 2c · Qué lo puede explicar

- **Anomalía técnica:** candidata fuerte — una fuga en el camión de 8707GBG explicaría el
  exceso del contador y, de paso, sus incidencias recurrentes.
- **Cambio significativo:** no: el exceso no depende de la fecha (la camión se sale todo el
  día 18/05, sin horas raras ni médicos).
- **Fuerzas del mercado:** no aplica: es un registro de una empresa con su flota propia.
- **Iniciativas propias:** no — no hubo campaña ni cambio de proceso en la ventana del dato.

Y también descartamos las explicaciones fáciles con el oro: no es el **corte de lavado**
(el mapa de calor no muestra el patrón dispar) ni **quién lava** (8707GBG gasta lo mismo con cada operario; el exceso de Alba
Sánchez es transversal a toda la flota, no propio de esta furgoneta).

El mapa de calor de la portada es esta comprobación: el exceso aparece en la fila de
8707GBG entera, de lavado en lavado — si fuera mezcla de servicios, su fila se vería como la
de cualquier otra.

## Paso 3 · Qué datos entran y cuáles se quedan fuera

| Dato candidato | ¿Pasa el filtro? | Dónde se usa |
|---|---|---|
| Parte diario (687 servicios, 06/04–15/05) | Sí | El «lo que declara»: litros por servicio y por furgoneta, y las incidencias. |
| Eventos del contador (14/05/2026, {{ stg_eventos.filas }} filas) | Sí | El «lo que mide»: base del puente parte–contador del titular. |
| Consumos corregidos en plata (recargas) | Sí | El día del contador y la prueba de que la corrección es imprescindible. |
| Ingresos por tipo de servicio y hora (P1) | No | Salta: no cambia la decisión del titular; otra historia que me la cuente ya el oro de la J3. |
| Operarios y tipos de lavado | Solo para descartar | Aparecen en el 2c (heat map) y en nada más: jamás como causa del hueco. |

### El contraste sin limpiar frente a limpio

Si en plata restamos sin pensar, las recargas vuelven negativas y el ranking nace impossible:
la flota sale con litros irreales (−1,08 en 8109PGH: una furgoneta que «le va» el agua al término del día).
Con la regla «llenar el depósito + lo consumido» la señal del titular aguanta — y de hecho
solo existe después de corregir.

```grafico
titular: Sin corregir las recargas, el ranking no existe: litros negativos en media flota
modelo: historia_puente
barras: furgoneta → l_sv_sin_limpiar, l_por_servicio_contador
destacar: 8707GBG
leyenda: sin corregir, corregido
orden: desc
```

### ¿Y cuánto engaña un eje cortado?

La flota vive entre 16,89 y 26,96 litros por servicio. Si alguien recorta el eje en 15
—un valor por debajo de todos— pasa esto:

```grafico
tipo: eje
titular: Mismos datos, dos lecturas: el eje manda
modelo: historia_puente
barras: furgoneta → l_por_servicio_contador
corte: 15
```

### El alcance

Los datos vienen de tres fuentes del caso EcoBrillo: **el parte diario** (para {{ stg_parte.filas }}
servicios del 06/04 al 15/05/2026 validos, de 698 filas en bronce tras deduplicar 10 repetidos),
**la agenda del contador** (lunes 18/05/2026, con las recargas ya corregidas en plata) y
**los registros de incidencias** del parte. Se ha quedado fuera todo lo que no cambiaba la
decisión: el detalle de ingreso por tipo, la agenda de operarios y los datos de la J1.

## Las cinco comprobaciones

1. **Hay una decisión detrás:** inspección de 8707GBG y auditoría del parte de mayo, con dueño y fecha (26/06/2026).
2. **El titular afirma, no describe:** «8707GBG mide un {{ historia_puente.hueco_pct[0] }} % más agua de lo que declara: al taller antes del 26 de junio».
3. **Cada cifra tiene fuente:** todas las cifras salen de marcas del oro (`historia_puente`, `historia_calor`, `historia_diaria`, `pregunta_3`); cada gráfico lleva el modelo al pie.
4. **La evidencia es diversa:** dos gráficos de barras distintos en la portada (puente e incidencias), y línea, histograma, calor y eje cortado en esta página — ningún hallazgo descansa en una única vista.
5. **Lo que no cuadra se dice:** el contador cubre un solo día (no un mes); la causa física (fuga vs sensor) solo la cierra el taller; y si el depósito real no fuera de 120 litros, la corrección de recargas movería la señal.
