------------------------------------------------------------
-- How to work with indexes
------------------------------------------------------------

DROP TABLE invoices;
DROP TABLE vendors;

CREATE TABLE vendors
(
  vendor_id                     NUMBER          NOT NULL,
  vendor_name                   VARCHAR2(50)    NOT NULL,
  vendor_address1               VARCHAR2(50),
  vendor_address2               VARCHAR2(50),
  vendor_city                   VARCHAR2(50)    NOT NULL,
  vendor_state                  CHAR(2)         NOT NULL,
  vendor_zip_code               VARCHAR2(20)    NOT NULL,
  vendor_phone                  VARCHAR2(50),
  vendor_contact_last_name      VARCHAR2(50),
  vendor_contact_first_name     VARCHAR2(50),
  CONSTRAINT vendors_pk 
    PRIMARY KEY (vendor_id),
  CONSTRAINT vendors_vendor_name_uq 
    UNIQUE (vendor_name)
);

CREATE INDEX vendors_vendor_name_upper_ix 
  ON vendors (UPPER(vendor_name));

CREATE UNIQUE INDEX vendors_vendor_phone_ix 
  ON vendors (vendor_phone); 

CREATE INDEX vendors_vendor_state_ix 
  ON vendors (vendor_state);

DROP INDEX vendors_vendor_state_ix;

CREATE TABLE invoices
(
  invoice_id            NUMBER          NOT NULL, 
  vendor_id             NUMBER          NOT NULL,
  invoice_number        VARCHAR2(50)    NOT NULL,
  invoice_date          DATE            NOT NULL,
  invoice_total         NUMBER(9,2)     NOT NULL,
  payment_total         NUMBER(9,2)                 DEFAULT 0,
  credit_total          NUMBER(9,2)                 DEFAULT 0,
  terms_id              NUMBER          NOT NULL,
  invoice_due_date      DATE            NOT NULL,
  payment_date          DATE,
  CONSTRAINT invoices_pk 
    PRIMARY KEY (invoice_id),
  CONSTRAINT invoices_fk_vendors
    FOREIGN KEY (vendor_id) 
    REFERENCES vendors (vendor_id)
);

CREATE INDEX invoices_vendor_id_ix
  ON invoices (vendor_id);
CREATE INDEX invoices_vendor_id_inv_no_ix
  ON invoices (vendor_id, invoice_number);
CREATE INDEX invoices_invoice_total_ix
  ON invoices (invoice_total DESC);
CREATE INDEX invoices_balance_due_ix
  ON invoices (invoice_total - payment_total - credit_total DESC);
  
  
  
  
  
  
  
  
  ------------------------------------------------------------------
  -- How to work with sequences
  ------------------------------------------------------------------
  
   
  DROP SEQUENCE vendor_id_seq;
  DROP SEQUENCE invoice_id_seq;
    
  DROP TABLE invoices;
  DROP TABLE vendors;
  
  CREATE TABLE vendors
  (
    vendor_id                     NUMBER          NOT NULL,
    vendor_name                   VARCHAR2(50)    NOT NULL,
    vendor_address1               VARCHAR2(50),
    vendor_address2               VARCHAR2(50),
    vendor_city                   VARCHAR2(50)    NOT NULL,
    vendor_state                  CHAR(2)         NOT NULL,
    vendor_zip_code               VARCHAR2(20)    NOT NULL,
    vendor_phone                  VARCHAR2(50),
    vendor_contact_last_name      VARCHAR2(50),
    vendor_contact_first_name     VARCHAR2(50),
    CONSTRAINT vendors_pk 
      PRIMARY KEY (vendor_id),
    CONSTRAINT vendors_vendor_name_uq 
      UNIQUE (vendor_name)
  );
  
  --CREATE SEQUENCE vendor_id_seq;
  CREATE SEQUENCE vendor_id_seq
    START WITH 124;
  --DROP SEQUENCE vendor_id_seq;
  
  INSERT INTO vendors 
  VALUES (vendor_id_seq.NEXTVAL, 'Acme Co.', '123 Main St.', NULL, 'Fresno', 'CA', '93711', '(800) 221-5528', 'Wiley' , 'Coyote');
  
  SELECT vendor_id_seq.CURRVAL from dual;
  
  CREATE TABLE invoices
  (
    invoice_id            NUMBER          NOT NULL, 
    vendor_id             NUMBER          NOT NULL,
    invoice_number        VARCHAR2(50)    NOT NULL,
    invoice_date          DATE            NOT NULL,
    invoice_total         NUMBER(9,2)     NOT NULL,
    payment_total         NUMBER(9,2)                 DEFAULT 0,
    credit_total          NUMBER(9,2)                 DEFAULT 0,
    terms_id              NUMBER          NOT NULL,
    invoice_due_date      DATE            NOT NULL,
    payment_date          DATE,
    CONSTRAINT invoices_pk 
      PRIMARY KEY (invoice_id),
    CONSTRAINT invoices_fk_vendors
      FOREIGN KEY (vendor_id) 
      REFERENCES vendors (vendor_id)
  );
  
  CREATE SEQUENCE invoice_id_seq
    START WITH 115;
  
  -- more examples
  CREATE SEQUENCE test_seq
    START WITH 100 INCREMENT BY 10
    MINVALUE 0 MAXVALUE 1000000
    CYCLE CACHE 10 ORDER;
    
  SELECT test_seq.NEXTVAL from dual;
  SELECT test_seq.CURRVAL from dual;
  SELECT test_seq.NEXTVAL from dual;
  SELECT test_seq.CURRVAL from dual;
    
  ALTER SEQUENCE test_seq
    INCREMENT BY 9
    MINVALUE 99 MAXVALUE 999999
    NOCYCLE CACHE 9 NOORDER;
  
  SELECT test_seq.NEXTVAL from dual;
  
DROP SEQUENCE test_seq;



--------------------------------------------------------
-- Use Sequence in Default on table
--------------------------------------------------------
-- use a squence as default value for the column
CREATE TABLE vendors
(
  vendor_id    NUMBER        DEFAULT vendor_id_seq.NEXTVAL PRIMARY KEY,
  vendor_name  VARCHAR2(50)  NOT NULL      UNIQUE
);


DROP TABLE vendors;


-- simple GENERATED clause
CREATE TABLE vendors
(
  vendor_id    NUMBER        GENERATED AS IDENTITY PRIMARY KEY,
  vendor_name  VARCHAR2(50)  NOT NULL      UNIQUE
);

DROP TABLE vendors;

--more complex GENERATED clause
CREATE TABLE vendors
(
  vendor_id    NUMBER        GENERATED BY DEFAULT AS IDENTITY ( START WITH 124) PRIMARY KEY,
  vendor_name  VARCHAR2(50)  NOT NULL      UNIQUE
);

-- Test DEFAULT keyword
INSERT INTO vendors VALUES (DEFAULT, 'default test');

-- Test column list
INSERT INTO vendors (vendor_name) VALUES ('column list test');

-- View results
SELECT * FROM vendors;