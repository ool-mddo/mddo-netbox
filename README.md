```bash
git clone -b release https://github.com/netbox-community/netbox-docker.git
cd netbox-docker
git checkout 3.1.1
```

demo/layer1_topololgy/netbox-docker ディレクトリ内に、以下のように docker-compose.override.yml を作成します。(docker-compose-override.yml.example をコピーして編集)

* 初回起動時にDB周りの設定処理が実行されますが、環境によっては時間がかかってヘルスチェックに引っかかり、起動が中断してしまいます。ヘルスチェックによる中断を避ける場合には `start_period` を変更してください。
- 初回の管理者(superuser)の登録・管理者用APIトークンの設定処理が変わりました(これまではデフォルトで用意されていたが、起動時に任意の管理者名・パスワードを指定して作るようになっています)。デフォルトでは起動時に superuser は作成されません。環境変数でこの動作を変更し、指定した管理者アカウント・トークンを起動時に作るように指定します。

```yaml
# playground/demo/layer1_topology/netbox-docker$ cat docker-compose.override.yml
services:
  netbox:
    image: ghcr.io/ool-mddo/mddo-netbox:main
    ports:
      - "8000:8080"
    # If you want the Nginx unit status page visible from the
    # outside of the container add the following port mapping:
    # - "8001:8081"
    healthcheck:
      # Time for which the health check can fail after the container is started.
      # This depends mostly on the performance of your database. On the first start,
      # when all tables need to be created the start_period should be higher than on
      # subsequent starts. For the first start after major version upgrades of NetBox
      # the start_period might also need to be set higher.
      # Default value in our docker-compose.yml is 60s
      start_period: 600s
    environment:
      SKIP_SUPERUSER: "false"
      SUPERUSER_API_TOKEN: "0123456789abcdef0123456789abcdef01234567"
      SUPERUSER_EMAIL: "admin@localhost"
      SUPERUSER_NAME: "admin"
      SUPERUSER_PASSWORD: "AdminPa55w0rd"
```
```yaml
# playground/demo/layer1_topology/netbox-docker$ cat docker-compose.yml
    volumes:
      #- ./configuration:/etc/netbox/config:z,ro <- /etc/netbox/configの部分をコメントアウトする
      - netbox-media-files:/opt/netbox/netbox/media:rw
      - netbox-reports-files:/opt/netbox/netbox/reports:rw
      - netbox-scripts-files:/opt/netbox/netbox/scripts:rw
