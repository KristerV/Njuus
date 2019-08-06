#!/usr/bin/env bash

set -e

cd /opt/build

mkdir -p /opt/build/rel/artifacts

export MIX_ENV=prod

echo "---------------------- Fetch deps"
mix local.rebar # Otherwise rebar is not available
rm -rf deps
rm -rf _build
mix deps.get --only prod

echo "---------------------- Run an explicit clean to remove any build artifacts from the host"
mix do clean, compile --force

echo "---------------------- Update static assets"
npm run deploy --prefix assets
chmod -R 777 priv/static
mix phx.digest

echo "---------------------- Build the release"
mix release

exit 0
