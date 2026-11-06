-- TEST PROTAGONISTA · un consumo de agua nunca es negativo.
-- Devuelve las filas que incumplen la regla; si el registro vuelve a cero al rellenar
-- el depósito, restar sin pensar miente. Rojo hasta entender el giro.
select furgoneta, ts, lectura_previa, contador_l, consumo_bruto_l, consumo_l
from {{ ref('stg_consumos') }}
where consumo_l < 0
