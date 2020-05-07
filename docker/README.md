# 公式のDockerイメージは以下

https://github.com/support-project/docker-knowledge

## ECRにアップする前に実施すること

### １．データベース接続先の変更
volumes/knowledge/custom_connection.xmlでDB接続先設定をカスタマイズできるようですので、作成したPostgreSQLの情報を使ってこのファイルを編集します。

変更後のイメージ
```
<connectionConfig>
        <name>custom</name>
        <driverClass>org.postgresql.Driver</driverClass>
        <URL>jdbc:postgresql://RDSのエンドポイント:ポート番号/DB名</URL>　←ここを変更
        <user>postgres</user>
        <password>mysql123</password>
        <schema>public</schema>
        <maxConn>0</maxConn>
        <autocommit>false</autocommit>
</connectionConfig>
```


### ２．Dockerfile の編集
さきほど編集した custom_connection.xml が コンテナ起動時に適用されるようにします。

```
VOLUME [ "/root/.knowledge" ]
COPY ./volumes/knowledge/custom_connection.xml /root/.knowledge/　←ここを追加
EXPOSE 8080
```

## ECRにイメージをアップロード
前提としてコンソールにログインしてリポジトリを作成しておく

### １．ECRへログイン
```
aws ecr get-login --no-include-email --region ap-northeast-1 > login.sh
bash login.sh
```

### ２．Docker Image の作成

```
docker build -t knowledge .
```

### ３．タグ付け
```
docker tag knowledge:latest ECRのリポジトリ名/knowledge:latest
```

### ４．プッシュ
```
docker push ECRのリポジトリ名/knowledge:latest
```
