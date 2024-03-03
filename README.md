<p align="center">
  <img width="715" height="350" src="Image/pamflet.png">
</p>

<div align="center">

# Database Penjualan Sigmaria Market

[Tentang](#scroll-tentang)
•
[Screenshot](#rice_scene-screenshot)
•
[Demo](#dvd-demo)
•
[Dokumentasi](#blue_book-dokumentasi)

</div>

## :bookmark_tabs: Menu

- [Tentang](#scroll-tentang)
- [Screenshot](#rice_scene-screenshot)
- [Demo](#dvd-demo)
- [Dokumentasi](#blue_book-dokumentasi)
- [Requirements](#exclamation-requirements)
- [Skema Database](#floppy_disk-skema-database)
- [ERD](#rotating_light-erd)
- [Deskripsi Data](#heavy_check_mark-deskripsi-data)
- [Struktur Folder](#open_file_folder-struktur-folder)
- [Tim Pengembang](#smiley_cat-tim-pengembang)

## Info

Sigmaria Market Online Shop adalah 


## :blue_book: Tentang

Project akhir mata kuliah Manajemen Data Statistika mengambil topik tentang Database Sigmaria Market Online Shop. Project ini mengspesifikasikan analisis pola penjualan berbagai produk, customer, transaksi, metode pembayaran dan voucher yang disediakan dalam online shop. Kumpulan data yang digunakan dalam proyek ini bersumber dari Kaggle. Hasil yang diharapkan adalah terbentuknya sebuah platform manajemen database berupa web application yang dapat memudahkan user dalam menganalisis untuk meningkatkan dan mengoptimalkan strategi penjualan. User dapat mencari data berdasarkan kategori yang di inginkan, misalnya pencarian berbagai macam produk, voucher yang disediakan dan lain-lain.

## :rice_scene: Screenshot

<p align="center">
  <img width="900" height="500" src="Image/pamflet.png">
</p>

## :dvd: Demo

Berikut merupakan link untuk shinnyapps atau dashboard dari project kami:


## :exclamation: Requirements

- Scrapping data menggunakan package R yaitu `rvest` dengan pendukung package lainnya seperti `tidyverse`,`rio`,`kableExtra` dan `stingr`  
- RDBMS yang digunakan adalah PostgreSQL dan ElephantSQL
- Dashboard menggunakan `shinny`, `shinnythemes`, `bs4Dash`, `DT`, dan `dplyr` dari package R

## :floppy_disk: Skema Database

Menggambarkan struktur *primary key* **customer**, **voucher**, **pay_method** dan **product** dengan *foreign key* **transaction** dalam membangun relasi antara tabel atau entitas.
<p align="center">
  <img width="600" height="400" src="Image/MDS_Graph-Schema.drawio.png">
</p>


## :rotating_light: ERD

ERD (Entity Relationship Diagram) menampilkan hubungan antara entitas dengan atribut. Pada project ini, seluruh atribut pada entitas produk, customer, voucher, dan metode pembayaran berhubungan dengan entitas transaksi.

<p align="center">
  <img width="600" height="400" src="Image/online_shop_erd.png">
</p>

## :heavy_check_mark: Deskripsi Data

Berisi tentang tabel-tabel yang digunakan berikut dengan sintaks SQL DDL (CREATE).

### Create Database
Database Sigmaria Market Online Shop menyimpan informasi yang mewakili atribut data yang saling berhubungan untuk kemudian dianalisis.
```sql
CREATE DATABASE sinta_jurnal
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
```
### Create Table Instansi
Table instansi memberikan informasi kepada user mengenai lembaga asal penulis jurnal sinta, sehingga user dapat mengetahui id instansi penulis, nama instansi penulis, jumlah penulis pada instansi tersebut, jumlah departemen pada instansi dan jumlah jurnal yang telah diterbitkan oleh setiap instansi. Berikut deskripsi untuk setiap tabel instansi.
| Attribute          | Type                  | Description                     |
|:-------------------|:----------------------|:--------------------------------|
| id_instansi        | character varying(10) | Id Instansi                     |
| nama_instansi      | character varying(10) | Nama Instansi                   |
| lokasi             | character varying(50) | Lokasi                          |
| jumlah_penulis     | smallint 	     | Jumlah Penulis                  |
| jumlah_depaetemen  | smallint		     | Jumlah Departemen               |
| jumlah_journals    | smallint              | Jumlah Jurnal yang Diterbitkan  |

dengan script SQL sebagai berikut:
```sql
CREATE TABLE IF NOT EXISTS public.instansi (
    id_instansi varchar(10) NOT NULL,
    nama_instansi varchar(100) NOT NULL,
    lokasi varchar(200),
	jumlah_penulis int,
	jumlah_departement int,
	jumlah_journals int,
    PRIMARY KEY (id_instansi)
);
```
### Create Table Departement
Table departemen memberikan informasi yang memudahkan user mengetahui asal penulis melalui id departemen penulis, id instansi penulis dan nama departemen penulis terkait. Id departemen adalah kode yang digunakan untuk membedakan nama departemen yang sama pada tiap instansi. Berikut deskripsi untuk setiap tabel departemen.
| Attribute          | Type                  | Description                     |
|:-------------------|:----------------------|:--------------------------------|
| id_dept            | character varying(10) | Id Departemen                   |
| id_instansi        | character varying(10) | Id Instansi                     |
| nama_instansi      | character varying(50) | Nama Instansi                   |

dengan script SQL sebagai berikut:
```sql
CREATE TABLE IF NOT EXISTS public.departemen (
    id_dept varchar(10) COLLATE pg_catalog."default" NOT NULL,
    id_instansi varchar(10) COLLATE pg_catalog."default" NOT NULL,
    nama_departemen varchar(100),
    CONSTRAINT departemen_pkey PRIMARY KEY (id_dept),
    CONSTRAINT departemen_id_instansi_fkey FOREIGN KEY (id_instansi)
        REFERENCES public.instansi (id_instansi) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
```
### Create Table Penulis
Table penulis memberikan informasi kepada user mengenai beberapa identitas penulis jurnal. User dapat mengetahui id sinta dari penulis, nama penulis jurnal, asal penulis melalui id instnasi dan id departemen. Selain itu, terdapat informasi mengenai jumlah artikel yang telah diterbitkan oleh penulis baik terindeks scopus maupun google scholar. Berikut deskripsi untuk setiap tabel penulis.
| Attribute                  | Type                  | Description                     		       |
|:---------------------------|:----------------------|:------------------------------------------------|
| id_sinta                   | character varying(10) | Id Sinta                       		       |
| nama_penulis               | character varying(100)| Nama Penulis                   		       |
| id_instansi                | character varying(10) | Id Instansi                     		       |	
| id_dept                    | character varying(10) | Id Departemen                 		       |
| subject_list               | character varying(150)| Bidang Ilmu yang Dikuasai Penulis               |
| sinta_score_ovr    	     | smallint              | Jumlah Skor Sinta                               |
| jumlah_article_scopus      | smallint		     | Jumlah Artikel yang Terbitkan oleh Scopus       |
| jumlah_article_gscholar    | smallint              | Jumlah Artikel yang Terbitkan oleh Google Sholar|

dengan script SQL sebagai berikut:
```sql
CREATE TABLE IF NOT EXISTS public.penulis (
    id_sinta varchar(10) COLLATE pg_catalog."default" NOT NULL,
    nama_penulis char(100) NOT NULL, 
    id_instansi varchar(10) COLLATE pg_catalog."default" NOT NULL,
    id_dept varchar(10) COLLATE pg_catalog."default" NOT NULL,
    subject_list varchar(200),
    sinta_score_ovr int,
    jumlah_article_scopus int,
    jumlah_article_gscholar int,
    CONSTRAINT penulis_pkey PRIMARY KEY (id_sinta),
    CONSTRAINT penulis_id_instansi_fkey FOREIGN KEY (id_instansi)
        REFERENCES public.instansi (id_instansi) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT penulis_id_departemen_fkey FOREIGN KEY (id_dept)
        REFERENCES public.departemen (id_dept) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
```
### Create Table Judul
Table judul menyajikan informasi lengkap mengenai sebuah artikel. Selain dapat mengetahui judul, user juga akan mendapatkan informasi doi dan tahun terbit sebuah artikel. Nama penulis, team penulis hingga urutan penulis tersaji pada table ini. Tidak hanya itu, akan ditampilkan pula nama penerbit dan nama jurnal yang dipercayakan penulis untuk mempublikasikan karyanya. Lebih lanjut, informasi spesifik mengenai id sinta, id departemen, id instansi dan id paper dapat diketahui melalui table ini.  Berikut deskripsi untuk setiap tabel judul.
| Attribute                  | Type                  | Description                     		       |
|:---------------------------|:----------------------|:------------------------------------------------|
| id_sinta                   | character varying(10) | Id Sinta                       		       |
| id_instansi                | character varying(10) | Id Instansi                  		       |
| id_dept                    | character varying(10) | Id Departemen                   		       |	
| id_paper                   | character varying(10) | Id Jurnal/Artikel                	       |
| judul_paper                | character varying(200)| Judul Paper                                     |
| nama_penerbit    	     | character varying(100)| Nama Penerbit                                   |
| nama_journal               | character varying(100)| nama_journal     			       |
| jenulis_ke		     | smallint              | Urutan Nama Penulis pada Jurnal		       |
| jumlah_penulis             | smallint		     | Jumlah Penulis                    	       |
| team_penulis               | character varying(100)| Nama-Nama Penulis                               |
| tahun_terbit    	     | character varying(4)  | Tahun Terbit                                    |
| doi	                     | character varying(50) | Tautan Persisten yang Menghubungkan ke Jurnal   |
| accred		     | character varying(10) | Akreditasi            			       |

dengan script SQL sebagai berikut:              
```sql
CREATE TABLE IF NOT EXISTS public.judul (
    id_sinta varchar(10) COLLATE pg_catalog."default" NOT NULL,
    id_instansi varchar(10) COLLATE pg_catalog."default" NOT NULL,
    id_dept varchar(10) COLLATE pg_catalog."default" NOT NULL, 
    id_paper varchar(10) COLLATE pg_catalog."default" NOT NULL,  
    judul_paper char(500) NOT NULL,
    nama_penerbit char(500),
    nama_journal char(500),
    penulis_ke int,
    jumlah_penulis int,
    team_penulis char(500),
    tahun_terbit char(4),
    doi char(100),
    accred char(50),    
    CONSTRAINT judul_pkey PRIMARY KEY (id_paper),
    CONSTRAINT judul_id_penulis_fkey FOREIGN KEY (id_sinta)
        REFERENCES public.penulis (id_sinta) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT judul_id_instansi_fkey FOREIGN KEY (id_instansi)
        REFERENCES public.instansi (id_instansi) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT judul_id_dept_fkey FOREIGN KEY (id_dept)
        REFERENCES public.departemen (id_dept) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
    );
```

## :open_file_folder: Struktur Folder

```
.
├── app           # ShinyApps
│   ├── css
│   │   ├── **/*.css
│   ├── server.R
│   └── ui.R
├── data 
│   ├── csv
│   │   ├── **/*.css
│   └── sql
|       └── db.sql
├── src           # Project source code
├── doc           # Doc for the project
├── .gitignore
├── LICENSE
└── README.md
```

## :smiley_cat: Tim Pengembang

- Backend Developer: [Rachmat Bintang Yudhianto](https://github.com/yudheeeeet) (G1501231030)
- Database Manager: [Tasya Anisah Rizqi](https://github.com/tasyaanisahrizqi) (G1501231046)
- Technical Writer: [Yunna Mentari Indah](https://github.com/yunnamentari) (G1501231017)
- Frontend Developer: [Uswatun Hasanah](https://github.com/hhyuss) (G1501222040)
