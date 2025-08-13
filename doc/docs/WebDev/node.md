# Node.js


List packages and version from `package-lock.json` using `jq`
```
cat package-lock.json | jq '[.dependencies | to_entries[] |  {"key": .key, "value": .value.version}] | from_entries'
```

