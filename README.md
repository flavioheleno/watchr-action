# watchr-action

Monitor your domain and certificates from GitHub Actions with [watchr](https://github.com/flavioheleno/watchr).

## Inputs

### check

**Required.** One of the available watchr checks (`domain` or `certificate`)

### domain

**Required.** The domain name to be checked (root domain for `check:domain` or FQDN for `check:certificate`)

### expiration_threshold

Number of days left to domain or certificate expiration that will trigger an error (default: `5` days)

### registrar_name

Match the domain Registrar Name (for `check:domain`)

### status_codes

List of Extensible Provisioning Protocol (EPP) status codes that should be active (CSV format) (default: `clientTransferProhibited`)

### issuer_name

Match the certificate Issuer Name (for `check:certificate`)

### fingerprint

Match the certificate SHA-256 Fingerprint (for `check:certificate`)

### serial_number

Match the certificate Serial Number (for `check:certificate`)

## Outputs

### status

The exit code returned by watchr check

### stdout

The stdout output generated by watchr check

## Examples

### Certificate Monitoring

```yaml
- name: Validate Certificate information
  uses: flavioheleno/watchr-action@main
  with:
    check: certificate
    domain: github.com
```

### Domain Monitoring

```yaml
- name: Validate Domain information
  uses: flavioheleno/watchr-action@main
  with:
    check: domain
    domain: github.com
```

## License

This project is licensed under the [MIT License](LICENSE).
