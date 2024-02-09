CREATE OR REPLACE FUNCTION insert_clean_metadatas()
RETURNS TRIGGER AS $$
BEGIN
    -- Your condition to determine which mapping table to use
    IF NEW.station LIKE 'station-0%' THEN
        INSERT INTO stations.metadatas_clean (project, client, station, station_type, wifi, volt_bateria, volt_panel, timestamp_arduino, is_valid, carga_bateria, potencia_panel)
        SELECT 
			t1.project, t1.client, t1.station,
			case 
				when station like 'station-0%' then 'gateway'
				when station like 'station-1%' then 'ambiente'
				when station like 'station-2%' then 'suelo'
			end station_type,
			t1.wifi,
			t1."voltBateria",
			t1."voltPanel",
			t1.timestamp_arduino,
			t1.is_valid
			t2.capacity AS carga_bateria,
			t3.capacity AS potencia_panel
        FROM NEW metadatas
        JOIN LATERAL (
            SELECT *
            FROM battery_12v t2
            ORDER BY ABS(NEW."voltBateria" - t2.voltage)
            LIMIT 1
        ) t2 ON true
		-- join for potencia panel t3
		;
    ELSE
        INSERT INTO stations.metadatas_clean (project, client, station, station_type, wifi, volt_bateria, volt_panel, timestamp_arduino, is_valid, carga_bateria, potencia_panel)
        SELECT 
			t1.project, t1.client, t1.station,
			case 
				when station like 'station-0%' then 'gateway'
				when station like 'station-1%' then 'ambiente'
				when station like 'station-2%' then 'suelo'
			end station_type,
			t1.wifi,
			t1."voltBateria",
			t1."voltPanel",
			t1.timestamp_arduino,
			t1.is_valid
			t2.capacity AS carga_bateria,
			t3.capacity AS potencia_panel
        FROM NEW metadatas
        JOIN LATERAL (
            SELECT *
            FROM battery_5v t2
            ORDER BY ABS(NEW."voltBateria" - t2.voltage)
            LIMIT 1
        ) t2 ON true
		-- join for potencia panel t3
		;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;