CREATE TABLE IF NOT EXISTS public.customer (
	CustomerID integer NOT NULL,
	Gender character varying(8) NOT NULL,
	Location character varying(50) NOT NULL,
	Age integer NOT NULL,
	PRIMARY KEY (CustomerID)
) 