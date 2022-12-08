DROP TABLE attendance;
DROP TABLE cert_records;
DROP TABLE certs;
DROP TABLE teacher_evals;
DROP TABLE teacher_classes;
DROP TABLE teachers;
DROP TABLE drop_ins;
DROP TABLE student_sections;
DROP TABLE sections;
DROP TABLE classes;
DROP TABLE waitlists;
DROP TABLE grad_records;
DROP TABLE programs;
DROP TABLE payments;
DROP TABLE accounts;
DROP TABLE student_evals;
DROP TABLE student_type;
DROP TABLE allergies;
DROP TABLE adult_to_student;
DROP TABLE students;
DROP TABLE pediatricians;
DROP TABLE adults;

CREATE TABLE adults
(
    adult_id        NUMBER(8) CONSTRAINT adults_adult_id_pk PRIMARY KEY,
    first_name      VARCHAR2(30),
    middle_name     VARCHAR2(30),
    last_name       VARCHAR2(30),
    address         VARCHAR2(50),
    birthdate       DATE,
    phone_num       VARCHAR2(15)
);

CREATE TABLE pediatricians
(
    doc_id          NUMBER(4) CONSTRAINT pediatricians_doc_id_pk PRIMARY KEY,
    first_name      VARCHAR(30),
    middle_name     VARCHAR(30),
    last_name       VARCHAR(30),
    phone_num       NUMBER(15)
);

CREATE TABLE students
(
    student_id      NUMBER(8) CONSTRAINT students_student_id_pk PRIMARY KEY,
    first_name      VARCHAR2(30),
    middle_name     VARCHAR2(30),
    last_name       VARCHAR2(30),
    address         VARCHAR2(50),
    ssn             VARCHAR2(9),
    phone_num       VARCHAR2(15),
    birthdate       DATE,
    pediatrician_id NUMBER(4) CONSTRAINT students_pediatrician_id_fk REFERENCES pediatricians(doc_id)
);

CREATE TABLE adult_to_student
(
    a_id                    NUMBER(8) CONSTRAINT adult_to_student_a_id_fk REFERENCES adults(adult_id),
    s_id                    NUMBER(8) CONSTRAINT adult_to_student_s_id_fk REFERENCES students(student_id),
    parent_type             VARCHAR(15), -- Mother, Father, Stepfather, etc
    can_pickup              VARCHAR(5), -- TRUE or FALSE
    emergency_contact_type  VARCHAR(15),
    CONSTRAINT adult_to_student_a_id_s_id_pk PRIMARY KEY (a_id, s_id)
);

CREATE TABLE allergies
(
    allergy_id NUMBER(9) CONSTRAINT allergies_allergy_id_pk PRIMARY KEY,
    student_id NUMBER(8) CONSTRAINT allergies_student_id_fk REFERENCES students(student_id),
    allergy    VARCHAR2(30)
);

CREATE TABLE student_type
(
    record_id       NUMBER(9) CONSTRAINT student_type_record_id_pk PRIMARY KEY,
    student_id      NUMBER(8) CONSTRAINT student_type_student_id_fk REFERENCES students(student_id),
    student_type    VARCHAR2(15)
);

CREATE TABLE student_evals
(
    evaluation_id           NUMBER(10) CONSTRAINT student_evals_evaluation_id_pk PRIMARY KEY,
    student_id              NUMBER(8) CONSTRAINT student_evals_student_id_fk REFERENCES students(student_id),
    evaluation_date         DATE,
    practical_life_skills   NUMBER(3),
    sensorial_activities    NUMBER(3),
    language_activities     NUMBER(3),
    cultural                NUMBER(3)
);

CREATE TABLE accounts
(
    account_id  NUMBER(8) CONSTRAINT accounts_account_id_pk PRIMARY KEY,
    student_id  NUMBER(8) CONSTRAINT accounts_student_id_fk REFERENCES students(student_id)
);

CREATE TABLE payments
(
    payment_id      NUMBER(10) CONSTRAINT payments_payment_id_pk PRIMARY KEY,
    account_id      NUMBER(8)  CONSTRAINT payments_account_id_fk REFERENCES accounts(account_id),
    payer_id        NUMBER(8)  CONSTRAINT payments_payer_id_fk REFERENCES adults(adult_id),
    payment_type    VARCHAR(20),
    payment_date    DATE,
    payment_method  VARCHAR(20),
    amount_paid     NUMBER(8,2)
);

CREATE TABLE programs
(
    program_id      NUMBER(3) CONSTRAINT programs_program_id_pk PRIMARY KEY,
    program_name    VARCHAR(20)
);

CREATE TABLE grad_records
(
    record_id       NUMBER(10) CONSTRAINT grad_records_record_id_pk PRIMARY KEY,
    program_id      NUMBER(3) CONSTRAINT grad_records_program_id_fk REFERENCES programs(program_id),
    student_id      NUMBER(8) CONSTRAINT grad_records_student_id_fk REFERENCES students(student_id),
    grad_date       DATE 
);

CREATE TABLE waitlists
(
    waitlist_id NUMBER(4) CONSTRAINT waitlists_waitlist_id_pk PRIMARY KEY,
    program_id  NUMBER(3) CONSTRAINT waitlists_program_id_fk REFERENCES programs(program_id),
    student_id  NUMBER(8) CONSTRAINT waitlists_student_id_fk REFERENCES students(student_id),
    date_added  DATE
);

CREATE TABLE classes
(
    class_id        NUMBER(4) CONSTRAINT classes_class_id_pk PRIMARY KEY,
    classroom_name  VARCHAR(30),
    capacity        NUMBER(3),
    program_id      NUMBER(3) CONSTRAINT classes_program_id_fk REFERENCES programs(program_id)
);

CREATE TABLE sections
(
    sect_id             NUMBER(5),
    class_id            NUMBER(4) CONSTRAINT sections_class_id_fk REFERENCES classes(class_id),
    session_time        VARCHAR(20),
    tuition_deposit     NUMBER(6,2),
    one_payment_cost    NUMBER(7,2),
    two_payment_cost    NUMBER(7,2),
    ten_payment_cost    NUMBER(7,2),
    school_year         VARCHAR(10),
    registration_fee    NUMBER(6,2),
    CONSTRAINT sections_sect_id_class_id_pk PRIMARY KEY (sect_id, class_id)
);

CREATE TABLE student_sections
(
    assign_id           NUMBER(10) CONSTRAINT student_sections_assign_id_pk PRIMARY KEY,
    student_id          NUMBER(8) CONSTRAINT student_sections_student_id_fk REFERENCES students(student_id),
    s_id                NUMBER(5),
    c_id                NUMBER(4),
    start_date          DATE,
    payment_frequency   VARCHAR(10),
    CONSTRAINT student_sections_s_id_c_id_fk FOREIGN KEY (s_id, c_id) REFERENCES sections(sect_id, class_id)
);

CREATE TABLE drop_ins
(
    record_id           NUMBER(10) CONSTRAINT drop_ins_record_id_pk PRIMARY KEY,
    student_id          NUMBER(8) CONSTRAINT drop_ins_student_id_fk REFERENCES students(student_id),
    sect_id             NUMBER(5), -- Section ID
    class_id            NUMBER(4), -- Class ID
    drop_in_date        DATE,
    CONSTRAINT drop_ins_sect_id_class_id_fk FOREIGN KEY (sect_id, class_id) REFERENCES sections(sect_id, class_id)
);

CREATE TABLE teachers
(
    teacher_id  NUMBER(5) CONSTRAINT teachers_teacher_id_pk PRIMARY KEY,
    first_name  VARCHAR(30),
    middle_name VARCHAR(30),
    last_name   VARCHAR(30)
);

CREATE TABLE teacher_classes
(
    assigned_id     NUMBER(8) CONSTRAINT teacher_classes_assigned_id_pk PRIMARY KEY,
    teacher_id      NUMBER(5) CONSTRAINT teacher_classes_teacher_id_fk REFERENCES teachers(teacher_id),
    class_id        NUMBER(4) CONSTRAINT teacher_classes_class_id_fk REFERENCES classes(class_id),
    position        VARCHAR(20)
);

CREATE TABLE teacher_evals
(
    evaluation_id           NUMBER(8) CONSTRAINT teacher_evals_evaluation_id_pk PRIMARY KEY,
    teacher_id              NUMBER(5) CONSTRAINT teacher_evals_teacher_id_fk REFERENCES teachers(teacher_id),
    evaluation_date         DATE,
    evaluation              NUMBER(3) -- Out of 100
);

CREATE TABLE certs
(
    certification_id        NUMBER(5) CONSTRAINT certs_certification_id_pk PRIMARY KEY,
    certification_name      VARCHAR(50),
    certification_provider  VARCHAR(50)
);

CREATE TABLE cert_records
(
    record_id               NUMBER(7) CONSTRAINT cert_records_record_id_pk PRIMARY KEY,
    teacher_id              NUMBER(5) CONSTRAINT cert_records_teacher_id_fk REFERENCES teachers(teacher_id),
    cert_id                 NUMBER(5) CONSTRAINT cert_records_cert_id_fk REFERENCES certs(certification_id),
    obtained_date           DATE,
    certification_progress  VARCHAR(15),
    required                VARCHAR(10) -- T/F, Y/N, IDC
);

CREATE TABLE attendance
(
    attendance_id       NUMBER(10) CONSTRAINT attendance_attendance_id_pk PRIMARY KEY,
    sect_id             NUMBER(5),
    class_id            NUMBER(4),
    student_id          NUMBER(8) CONSTRAINT attendance_student_id_fk REFERENCES students(student_id),
    teacher_id          NUMBER(5) CONSTRAINT attendance_teacher_id_fk REFERENCES teachers(teacher_id),
    record_timestamp    TIMESTAMP, -- Timestamp includes Date and Time
    CONSTRAINT attendance_sect_id_class_id_fk FOREIGN KEY (sect_id, class_id) REFERENCES sections(sect_id, class_id)
);