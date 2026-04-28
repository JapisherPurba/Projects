-- ACS-3902 Assignment 2 Part B
-- Name: Japisher Singh Purba
-- St#: 3183522
--------------------------------
SET SCHEMA 'purba_3183522_as2_a_b';  -- change the schema name to match your own

rollback
-- Part B2:  Creating FK Constraints with RI Actions
-----------------------------------------------------------------------------

BEGIN ;
ALTER TABLE cleaninginvoiceitem 
DROP CONSTRAINT IF EXISTS FK_ServiceItem;

ALTER TABLE Customer
ADD CONSTRAINT FK_SalesRepNumber
FOREIGN KEY (SalesRepNumber) REFERENCES SalesRep(SalesRepNumber)
ON DELETE SET NULL
ON UPDATE CASCADE;

ALTER TABLE CleaningInvoice
ADD CONSTRAINT FK_CleaningInvoice_BookingSource
FOREIGN KEY (BookingSourceID) REFERENCES BookingSource(BookingSourceID)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE CleaningInvoice
ADD CONSTRAINT FK_CleaningInvoice_Customer
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE cleaninginvoiceitem
ADD CONSTRAINT FK_CleaningInvoiceItem_Invoice
FOREIGN KEY (CleaningInvoiceNumber) REFERENCES CleaningInvoice(CleaningInvoiceNumber)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE cleaninginvoiceitem
ADD CONSTRAINT FK_CleaningInvoiceItem_ServiceItem
FOREIGN KEY (ServiceItemID) REFERENCES ServiceItem(ServiceItemID)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE CustomerReferral
ADD CONSTRAINT FK_CustomerReferral_ReferringCustomer
FOREIGN KEY (ReferringCustomer) REFERENCES Customer(CustomerID)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE CustomerReferral
ADD CONSTRAINT FK_CustomerReferral_ReferredCustomer
FOREIGN KEY (ReferredCustomer) REFERENCES Customer(CustomerID)
ON DELETE RESTRICT
ON UPDATE CASCADE;

END;