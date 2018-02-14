## Objectives
- Describe what I have done on AWS RDS + EC2 + Lambda
- 定期在某一個地方可以使用最近的稅籍資料

## Components

| component name | region |
|--|--|
| Lambda | Tokyo |
| EC2 | Tokyo |
| RDS (PostgreSQL) | N. Virginia |

## flow
### Lambda (Region: Tokyo)
- 在 Region: Tokyo 的 Lambda function ``` start-ec2-for-fubon-opendata ``` 設定 UTC 19:00 啟動在 Region 在 Tokyo 的 EC2 instance (ec2 id: i-088c7864e0bb0f160)

### EC2 instance (Region: Tokyo)
- 在 Tokyo 的 EC2 instance 會在 UTC 19:05 使用帳號: ``` root ``` 在 /home/centos/opendata/bgopen1.sh, 如果要看執行時間, 可以用帳號: ``` root ``` 下 ```crontab -l``` 看一下

```
# whoami
root
# crontab -l 
5 19 * * * /bin/sh /home/centos/opendata/bgopen1.sh >> /home/centos/opendata/log/bgopen1.log 2>&1
```
- 另外, 在這個 EC2 instance 上面有用一個 Elastic IP: 13.230.246.190, 這是目前唯一不在 Free Tier 的項目, 一個月預估約 $3 USD, 大概是 100 元台幣
#### bgopen1.sh 邏輯
1. 從政府公開資料網站 (https://data.gov.tw/dataset/9400) 下載最新的稅籍資料
2. 和前一天下載的稅籍資料比對, 如果檔案的 md5 相同, 就會結束了, 如果 md5 不同, 會繼續下一步驟
3. 移除 RDS (database name: fubon_open_data) 的 table: bgopen1 裡面所有資料
4. 過濾欄位數量不同的資料, 預設是會過濾欄位不等於 15 個的資料
5. 將過濾完的資料放到 RDS (database name: fubon_open_data) 的 table (bgopen1) 
6. 執行完上述步驟, 下 ``` shutdown -h now ``` 關掉主機

### RDS (Region: N. Virginia)
- 連線資訊

| 項目 | 內容 |
|--|--|
| 帳號 | fubon |
| 密碼 | ****** |
| Port | 5432 |
| JDBC Connection URL | jdbc:postgresql://fubon-data.ccxwpm2mpssl.us-east-1.rds.amazonaws.com:5432/fubon_opendata_db |

- 資料庫: fubon_open_data
- 用途

| table | 用途 |
|--|--|
|bgopen1 | 稅籍資料 |

## 特別注意
- 預計會在 2018 年 11 月 30 日停下所有服務, 所以如果需要的話, 可以將資料進行備份

## References
- 稅籍資料: https://data.gov.tw/dataset/9400
- AWS lambda 範例: https://aws.amazon.com/tw/premiumsupport/knowledge-center/start-stop-lambda-cloudwatch/
- AWS RDS (PostgreSQL): https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_GettingStarted.CreatingConnecting.PostgreSQL.html

