CREATE DATABASE IF NOT EXISTS thikhaosat2;
USE thikhaosat2;

CREATE TABLE majors (
    major_id VARCHAR(5) PRIMARY KEY,
    major_name VARCHAR(150) NOT NULL UNIQUE,
    department VARCHAR(100) NOT NULL,
    duration_years INT NOT NULL,
    tuition_fee DECIMAL(15,2) NOT NULL CHECK (tuition_fee > 0), 
    status VARCHAR(20) NOT NULL DEFAULT 'Active' 
);

CREATE TABLE candidates (
    candidate_id VARCHAR(5) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL,
    hometown VARCHAR(100) NOT NULL
);
ALTER TABLE candidates ADD COLUMN birth_year INT;

CREATE TABLE applications (
    app_id INT AUTO_INCREMENT PRIMARY KEY,
    candidate_id VARCHAR(5) NOT NULL,
    major_id VARCHAR(5) NOT NULL,
    apply_date DATE NOT NULL,
    priority_score DECIMAL(4,2),
    FOREIGN KEY (candidate_id) REFERENCES candidates(candidate_id),
    FOREIGN KEY (major_id) REFERENCES majors(major_id)
);
CREATE TABLE admissions (
    admission_id INT AUTO_INCREMENT PRIMARY KEY,
    app_id INT NOT NULL,
    total_score DECIMAL(4,2) NOT NULL,
    result VARCHAR(50) NOT NULL, 
    FOREIGN KEY (app_id) REFERENCES applications(app_id)
);

INSERT INTO majors (major_id, major_name, department, duration_years, tuition_fee, status) 
VALUES
('M01', 'Công nghệ thông tin', 'CNTT', 4, 30000000.00, 'Active'), 
('M02', 'Quản trị kinh doanh', 'Kinh tế', 4, 25000000.00, 'Active'), 
('M03', 'Ngôn ngữ Anh', 'Ngoại ngữ', 4, 22000000.00, 'Full'), 
('M04', 'Kỹ thuật ô tô', 'Cơ khí', 5, 28000000.00, 'Active'), 
('M05', 'Trí tuệ nhân tạo', 'CNTT', 4, 45000000.00, 'Active');

INSERT INTO candidates (candidate_id, full_name, email, phone, hometown, birth_year) 
VALUES
('C01', 'Nguyễn Phan Anh', 'anh.np@gmail.com', '0912345678', 'Hà Nội', 2006), 
('C02', 'Trần Thị Mai', 'mai.tt@gmail.com', '0987654321', 'Đà Nẵng', 2006), 
('C03', 'Nguyễn Minh Khôi', 'khoi.nm@gmail.com', '0944556677', 'Hải Phòng', 2005), 
('C04', 'Lê Bảo Châu', 'chau.lb@gmail.com', '0966112233', 'TP HCM', 2006), 
('C05', 'Ngô Quang Đăng', 'dang.nq@gmail.com', '0977889900', 'Cần Thơ', 2006);
INSERT INTO applications (app_id, candidate_id, major_id, apply_date, priority_score)
VALUES
(1, 'C01', 'M01', '2025-11-10', 0.50), 
(2, 'C03', 'M05', '2025-11-12', 0.00), 
(3, 'C05', 'M01', '2025-11-15', 1.00), 
(4, 'C02', 'M02', '2025-12-01', 0.00), 
(5, 'C01', 'M05', '2025-12-05', 0.50), 
(6, 'C04', 'M03', '2025-12-10', 0.00);

INSERT INTO admissions (admission_id, app_id, total_score, result) 
VALUES
(1, 1, 27.50, 'Admitted'), 
(2, 2, 24.00, 'Pending'), 
(3, 3, 29.00, 'Admitted');
set sql_safe_updates = 0;
UPDATE candidates
SET hometown = 'Quảng Nam'
WHERE candidate_id = 'C02';

UPDATE majors
SET tuition_fee = tuition_fee * 0.9 
WHERE department = 'Ngoại ngữ';

DELETE FROM admissions
WHERE result = 'Rejected';

UPDATE majors 
SET status = 'Full'
WHERE tuition_fee > 40000000;

UPDATE applications
SET priority_score = '0'
WHERE apply_date BETWEEN '2025-11-01' AND '2025-11-30' AND priority_score IS NULL;
-- PHAN 1
-- caau 1 Liệt kê các ngành học có học phí từ 20,000,000 đến 30,000,000 VNĐ.
SELECT major_id, major_name, department, duration_years, tuition_fee, status
FROM majors 
WHERE tuition_fee BETWEEN 20000000 AND 30000000;
-- cau 2 Lấy full_name, email của thí sinh có họ 'Nguyễn'.
SELECT full_name, email 
FROM candidates 
WHERE full_name LIKE '%Nguyễn%';
-- cau 3 Hiển thị major_name, department, sắp xếp theo tuition_fee giảm dần.
SELECT major_name, department
FROM majors
ORDER BY tuition_fee DESC;
-- cau 4 Lấy ra 3 thí sinh có năm sinh (birth_year) nhỏ nhất (lớn tuổi nhất).
SELECT candidate_id, full_name, email, phone, hometown, birth_year
FROM candidates
ORDER BY birth_year ASC LIMIT 3;
-- cau 5: Hiển thị danh sách hồ sơ đăng ký (Applications) nộp trong tháng 11/2025.
SELECT app_id, candidate_id, major_id, apply_date, priority_score
FROM applications 
WHERE apply_date >= '2025-11-01' AND apply_date <= '2025-11-30';
-- cau 6: Tìm ngành học có tên bắt đầu bằng 'Công nghệ' hoặc kết thúc bằng 'Anh'.
SELECT major_id, major_name, department, duration_years, tuition_fee, status
FROM majors
WHERE major_name LIKE 'Công nghệ%' OR major_name LIKE '%Anh';
-- cau 7: Lấy thông tin hồ sơ có điểm ưu tiên nằm trong khoảng từ 0.25 đến 0.75.
SELECT app_id, candidate_id, major_id, apply_date, priority_score
FROM applications 
WHERE priority_score BETWEEN 0.25 AND 0.75;
-- cau 8: Sắp xếp danh sách thí sinh theo quê quán (hometown) từ A-Z.
SELECT candidate_id, full_name, email, phone, hometown, birth_year
FROM candidates ORDER BY hometown ASC;
-- NANG CAO
-- cau 1: Hiển thị app_id, full_name (thí sinh), major_name (ngành), apply_date của các thí sinh quê ở 'Hà Nội'.
SELECT a.app_id, c.full_name, m.major_name, a.apply_date
FROM applications a
JOIN candidates c ON a.candidate_id = c.candidate_id
JOIN majors m ON a.major_id = m.major_id
WHERE c.hometown = 'Hà Nội';
-- cau 2: Thống kê mỗi khoa (department) hiện có bao nhiêu ngành đào tạo.
SELECT department, COUNT(major_id) AS total_majors
FROM majors
GROUP BY department;
-- cau 3: Liệt kê tên ngành học và tổng số hồ sơ đã đăng ký vào ngành đó (hiển thị cả ngành chưa có hồ sơ).
SELECT m.major_name, COUNT(a.app_id) AS total_applications
FROM majors m
LEFT JOIN applications a ON m.major_id = a.major_id
GROUP BY m.major_id, m.major_name;
-- cau 4: Tìm các ngành học chưa từng có thí sinh nào đăng ký.
SELECT m.major_id, m.major_name, m.department, m.duration_years, m.tuition_fee, m.status
FROM majors m
LEFT JOIN applications a ON m.major_id = a.major_id
WHERE a.app_id IS NULL;
-- cau 5: Tính tổng học phí dự kiến thu được từ những thí sinh đã trúng tuyển (Admitted) theo từng ngành.
SELECT m.major_name, SUM(m.tuition_fee) AS total_revenue
FROM admissions ad
JOIN applications ap ON ad.app_id = ap.app_id
JOIN majors m ON ap.major_id = m.major_id
WHERE ad.result = 'Admitted'
GROUP BY m.major_id, m.major_name;
-- cau 6: Hiển thị tên các thí sinh đã nộp hồ sơ vào từ 2 ngành học khác nhau trở lên.
SELECT c.full_name
FROM candidates c
JOIN applications a ON c.candidate_id = a.candidate_id
GROUP BY c.candidate_id, c.full_name
HAVING COUNT(DISTINCT a.major_id) >= 2;
-- cau 7: Tìm ngành học có mức học phí cao nhất trong hệ thống.
SELECT major_id, major_name, department, duration_years, tuition_fee, status
FROM majors 
WHERE tuition_fee = (SELECT MAX(tuition_fee) FROM majors);
-- cau 8: Liệt kê thông tin các thí sinh sinh năm 2006 đã trúng tuyển vào khoa 'CNTT'.  
SELECT DISTINCT c.candidate_id, c.full_name, c.email, c.phone, c.hometown, c.birth_year
FROM candidates c
JOIN applications ap ON c.candidate_id = ap.candidate_id
JOIN majors m ON ap.major_id = m.major_id
JOIN admissions ad ON ap.app_id = ad.app_id
WHERE c.birth_year = 2006 AND m.department = 'CNTT' AND ad.result = 'Admitted';








