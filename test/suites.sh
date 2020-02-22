#!/bin/sh
set -eu

cat <<EOF
==> test nodejs 10.x
EOF
node --version | grep 'v10' || exit 1

cat <<EOF
==> test yarn 1.21.x
EOF
yarn --version | grep '1.21.[0-9]' || exit 1

cat <<EOF
==> test typescript 3.x
EOF
tsc --version | grep '3.[0-9]' || exit 1

cat <<EOF
==> test ts-node 8.x
EOF
ts-node --version | grep 'v8' || exit 1

cat <<EOF
==> test aws-cdk 1.25.x
EOF
cdk --version | grep '1.25.[0-9]' || exit 1

cat <<EOF
==> test aws-cli 1.18.x
EOF
aws --version | grep 'aws-cli/1.18.[0-9]' || exit 1
aws --version | grep 'Python/3.6.[0-9]' || exit 1

cat <<EOF
==> test docker 19.x
EOF
docker --version | grep '19.[0-9]' || exit 1

cat <<EOF
==> test docker build
EOF
echo "FROM alpine" | docker build -t test -
docker run test

cat > test.erl <<EOF
-module(test).
-export([main/1]).
main(_) -> io:format("==> Hello World!~n").
EOF
erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().' -noshell | grep '"20"' || exit 1
erlc test.erl
escript test.erl
