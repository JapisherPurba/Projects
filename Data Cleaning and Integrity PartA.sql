-- ACS-3902 Assignment 2 Part A
-- Name: Japisher Singh Purba
-- St#:3183522
--------------------------------
SET SCHEMA 'purba_3183522_as2_a_b';  -- change the schema name to match your own


-- Part A.1: Correcting Duplicate Data in the Cleaning Invoice Detail Table
-----------------------------------------------------------------------------
-- Question A.1.1
SELECT *
FROM cleaninginvoiceitem
WHERE (CleaningInvoiceNumber, InvoiceLineItemNumber) IN (
    SELECT CleaningInvoiceNumber, InvoiceLineItemNumber
    FROM CleaningInvoiceItem
    GROUP BY CleaningInvoiceNumber, InvoiceLineItemNumber
    HAVING COUNT(*) > 1
);
rollback

-- Question A.1.2
UPDATE cleaninginvoiceitem
SET invoicelineitemnumber = 2
WHERE cleaninginvoicenumber = 4 AND serviceitemid = '3';

UPDATE cleaninginvoiceitem
SET invoicelineitemnumber = 3
WHERE cleaninginvoicenumber = 4 AND serviceitemid = '9';
UPDATE cleaninginvoiceitem
SET invoicelineitemnumber = 3
WHERE cleaninginvoicenumber = 6 AND serviceitemid = '12' 

UPDATE cleaninginvoiceitem
SET invoicelineitemnumber = 4
WHERE cleaninginvoicenumber = 6 AND serviceitemid = '6' AND servicequantity = 2;

UPDATE cleaninginvoiceitem
SET invoicelineitemnumber = 5
WHERE cleaninginvoicenumber = 6 AND serviceitemid = '3'
ALTER TABLE CleaningInvoiceItem
ADD PRIMARY KEY (CleaningInvoiceNumber, InvoiceLineItemNumber);
-- Part A.2: A.2 Correcting Service Item Codes
-----------------------------------------------------------------------------
-- Question A.2.1
SELECT 
    c.CustomerID, 
    c.BusinessName, 
    c.LastName, 
    ci.CleaningInvoiceNumber AS InvoiceID, 
    ci.BookingDate, 
    cii.InvoiceLineItemNumber, 
    cii.ServiceItemID
FROM CleaningInvoiceItem cii
 LEFT JOIN ServiceItem si ON cii.ServiceItemID = si.ServiceItemID
JOIN CleaningInvoice ci ON cii.CleaningInvoiceNumber = ci.CleaningInvoiceNumber
JOIN Customer c ON ci.CustomerID = c.CustomerID
WHERE si.ServiceItemID IS NULL
ORDER BY c.CustomerID, ci.BookingDate;


-- Question A2.2
BEGIN;
UPDATE cleaninginvoiceitem
SET serviceitemid = '1'
WHERE serviceitemid = '01';
UPDATE cleaninginvoiceitem
SET serviceitemid = '5'
WHERE serviceitemid = '05';
UPDATE cleaninginvoiceitem
SET serviceitemid = '6'
WHERE serviceitemid = '06';


UPDATE cleaninginvoiceitem
SET serviceitemid = 'UK'
WHERE serviceitemid IS NULL;

INSERT INTO serviceitem (serviceitemid, description, unittype, standardunitprice, category)
VALUES 
    ('OT', 'Other Services', 'Hour', 20, 'Other'),
    ('UK', 'Unknown', 'Unknown', 1, 'Other');

END;


-- Part A.3 Merging Duplicate Customer Records
-----------------------------------------------------------------------------

-- Question A.3.1 
SELECT 
    CustomerID, 
    CustomerType, 
    BusinessName, 
    FirstName, 
    LastName, 
	Email,
    Address, 
	City,
	State,
	PostalCode,
	SalesRepNumber
FROM Customer
WHERE (BusinessName, FirstName, LastName, Address, Email) IN (
    SELECT BusinessName, FirstName, LastName, Address, Email
    FROM Customer
    GROUP BY BusinessName, FirstName, LastName, Address, Email
    HAVING COUNT(*) > 1
)
ORDER BY CustomerID;
-- Question A.3.2
BEGIN;


UPDATE cleaninginvoice
SET customerid = 10
WHERE customerid = 11;

UPDATE customerreferral
SET referringcustomer = 10
WHERE referringcustomer = 11;

UPDATE customerreferral
SET referredcustomer = 10
WHERE referredcustomer = 11;


UPDATE cleaninginvoice
SET customerid = 18
WHERE customerid = 17;

UPDATE customerreferral
SET referringcustomer = 18
WHERE referringcustomer = 17;

UPDATE customerreferral
SET referredcustomer = 18
WHERE referredcustomer = 17;

DELETE FROM customer
WHERE customerid IN (11, 17);

END;



-- Question A.3.3
ALTER TABLE customer
ADD CONSTRAINT unique_customer_email UNIQUE (email);

ALTER TABLE customer
ADD CONSTRAINT unique_customer_name_address UNIQUE (firstname, lastname, address, city, state,postalcode);