CREATE TABLE util.logs (
	"name" varchar(1000) NULL,
	log_level varchar(20) NULL,
	start_date timestamp NULL,
	end_date timestamp NULL,
	message varchar(4000) NULL,
	"statement" text NULL
);
