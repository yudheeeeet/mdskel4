CREATE TABLE IF NOT EXISTS public.Customer (
    CustomerID character varying(11) NOT NULL,
    Gender character varying(11) NOT NULL,
    Locations text NOT NULL,
	Age integer NOT NULL,
    PRIMARY KEY (CustomerID)
);

CREATE TABLE IF NOT EXISTS public.Product (
    ProductID character varying(20) NOT NULL,
    Product_name text NOT NULL,
    Product_Description text NOT NULL,
	Product_Category text NOT NULL,
	Stock integer NOT NULL,
	Price numeric NOT NULL,
    PRIMARY KEY (ProductID)
);

CREATE TABLE IF NOT EXISTS public.Voucher (
    VoucherID character varying(11) NOT NULL,
    Voucher_name text NOT NULL,
	Discount integer NOT NULL,
	PRIMARY KEY (VoucherID)
);

CREATE TABLE IF NOT EXISTS public.Pay_method (
    PMID character varying(11) NOT NULL,
    Method_name text NOT NULL,
	PRIMARY KEY (PMID)
);

CREATE TABLE IF NOT EXISTS public.Transaction (
    TransactionID character varying(20) NOT NULL,
    Transaction_Date date NOT NULL,
    Total_price numeric NOT NULL,
	Quantity integer NOT NULL,
	CustomerID character varying(11) NOT NULL,
	ProductID character varying(20) NOT NULL,
	PMID character varying(11) NOT NULL,
	VoucherID character varying(11) NOT NULL,
	Voucher_status text NOT NULL,
	PRIMARY KEY (TransactionID),
	FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID),
	FOREIGN KEY (ProductID) REFERENCES Product (ProductID),
	FOREIGN KEY (PMID) REFERENCES Pay_method (PMID),
	FOREIGN KEY (VoucherID) REFERENCES Voucher (VoucherID)
);