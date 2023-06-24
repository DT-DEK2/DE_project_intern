<h1 align="center">Tiki Data Scraping and Datawarehouse Building Project
</h1>
<p align="center"><i>Nguyễn Đạt - Project intern tại DataGenius</i></p>
<p align=" justify">

- Người thực hiện: Nguyễn Đạt

- Địa chỉ email: nguyendat.uit@gmail.com
</p>

## Giới thiệu
<p align=" justify">
- Đây là dự án được thiết kế và thực hiện để phục vụ cho vòng phỏng vấn vị trí Intern Data Engineer tại công ty DataGenius. Project này, tôi sử dụng API của tiki để xây dựng pipeline stream (luồng dữ liệu trực tiếp để crawl và đẩy vào mysql) được mô tả như sau: Từ list category là danh sách người dùng muốn thu thập dữ liệu từ tiki sau đó tiến hành crawl product_id và thông tin chi tiết mỗi sản phẩm, mỗi quá trình đều được tiền xử lý xoá các bản ghi trùng lặp trước khi đẩy vào database. Sau khi có dữ liệu tiến hành phân cấp dữ liệu theo cấu trúc Star Schema (lược đồ hình sao).
</p>
<p>
- Công nghệ và thư viện sử dụng: Python, MySQL, </p>
- Tiki : https://tiki.vn/

</p>


## Mô tả quá trình Crawl Data
<p align=" justify">
- Phân tích trang tiki và thử tạo một mô hình datawarehouse theo Star Schema trước, mô hình này sẽ thay đổi liên tục để phù hợp với dữ liệu crawl được.
</p>

<p align=" justify">
- Crawl sản phẩm dựa vào list category, ở đây tôi đã crawl 5 danh mục bao gồm: "dien-thoai-may-tinh-bang, lam-dep-suc-khoe, nha-cua-doi-song, thiet-bi-kts-phu-kien-so,dong-ho-va-trang-suc" được nhập từ file Categories.txt từ những danh mục này trích xuất ra các product_id, để mở rộng sản phẩm lấy được thêm sort để lấy tất cả sản phẩm bảo gồm: default,top_seller , newest, price_asc, price_desc bao gồm sắp xếp mặc định, bán chạy,... tuy nhiên trong quá trình craw thì các product_id trùng -> đã xử lý id trùng trước khi lưu vào mysql,... tổng cộng crawl được 36285 product_id

</p>
</p>
<p align="center">
  <img src="picture/Crawl_Product_id.png" alt="Star Schema Diagram">
  <br>
  <em>Product ID lưu trực tiếp vào mysql đã xoá các id trùng</em>
</p>
<p align=" justify">
- Tiếp theo, load lại product_id từ mysql để crawl thông tin chi tiết mỗi sản phẩm, vì đây là luồng streams nên tôi đã sử dụng đa luồng để tăng tốc độ crawl xử lý 4 luồng, và ngoài ra vì luồng dữ liệu crawl lớn nên đã áp dụng các biện pháp để lặp lại đối với dữ liệu không thành công, vì quá trình streams với dữ liệu lớn nên không tránh được việc server chặn ip tuy nhiên đoạn code của tôi, tôi đã tối ưu trong khả năng việc bị chặn và lặp lại quá trình nếu lỗi,... chi tiết trong mã nguồn.
</p>
<p align="center">
  <img src="picture/Crawl_product_data.png" alt="Star Schema Diagram">
  <br>
  <em>Quá trình crawl sản phẩm</em>
</p>
</p>
<p align="center">
  <img src="picture/data_save_mysql.png" alt="Star Schema Diagram">
  <br>
  <em>Thông tin 36285 product từ 5 danh mục </em>
</p>
<p align=" justify">
# Mô tả quá trình Phân cấp dữ liệu và xây dựng Datawarehouse.
<p align="justify">
Vì hạn chế về dữ liệu crawl được nên tôi chỉ có thể xây dựng một mô hình datawarehouse theo cấu trúc Star Schema trong khả năng bao gồm 1 bảng fact: Fact_sales và 3 bản dim bao gồm Dim_Product, Dim_Brand, Dim_Category như sau:
</p>
<p align="center">
  <img src="DWH/final_star_schema.png" alt="Star Schema Diagram">
  <br>
  <em>Mô hình Star Schema</em>
</p>
</p>
<p align="center">
  <img src="picture/fact_sales.png" alt="Star Schema Diagram">
  <br>
  <em>Dữ liệu sau khi được đẩy vào fact_sales</em>
</p>
</p>
<p align="center">
  <img src="picture/dim_product.png" alt="Star Schema Diagram">
  <br>
  <em>Dữ liệu sau khi được đẩy vào dim_product</em>
</p>

<p align="center">
  <img src="picture/dim_category.png" alt="Star Schema Diagram">
  <br>
  <em>Dữ liệu sau khi được đẩy vào dim_brand</em>
</p>

## Cài đặt và hướng dẫn sử dụng:
- Cài đặt các thư viện tenacity, sqlalchemy,... trước khi khởi chạy chương trình.
- Thay đổi địa chỉ thư mục Categories.txt, mặc định phải tạo theo đường dẫn ./Data/Categories.txt
- Môi trường thử nghiệm: Python 3.11.4.
- Thay đổi tham số cấu hình MySQL phù hợp.
- Chạy file Craw_product.ipynb: Chương trình sẽ tự động tạo bảng, crawl product_id, product tiền xử lý dữ liệu trước khi lưu vào database
- Chạy file datawarehouse.ipynb: Để thực hiện quá trình connect, ETL,....



## Nhận xét: 
<p align="justify">
- Thông qua bài kiểm tra, tôi nhận thấy bài test khá thú vị và tôi đã học được rất nhiều điều từ dự án này, tuy nhiên còn một số vấn đề tôi chưa xử lý được, tôi hi vọng trong tương lai sẽ áp dụng các công cụ như Apache NiFi, Talend, hay StreamSets để đưa dữ liệu vào DW mà sử dụng trực tiếp python vì thời gian gấp rút cũng như với lượng database nhỏ nên tôi áp dụng luôn python. Hi vọng nếu được làm việc với công ty tôi sẽ cố gắng học hỏi và hoàn thiện bản thân hơn. Qua đây, tôi cũng trân trọng cảm ơn phía công ty đã giao project khá thú vị này cho tôi.
</p>


