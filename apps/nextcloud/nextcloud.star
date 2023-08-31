load("render.star", "render")
load("http.star", "http")
load("encoding/base64.star", "base64")
load("cache.star", "cache")
load("schema.star", "schema")

# token b7Cb0NTM0G9iJ4Rzh7rT
# server cloud.voklaf.ru
# pixlet render nextcloud.star server="cloud.voklaf.ru" token="b7Cb0NTM0G9iJ4Rzh7rT"
# pixlet push --installation-id nextcloud  beseechingly-succinct-keen-raptor-624 nextcloud.webp

CLOUD_STATUS_URL = "/ocs/v2.php/apps/serverinfo/api/v1/info?format=json"

CLOUD_ICON = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAABgAAAAMCAYAAAB4MH11AAAAxHpUWHRSYXcgcHJvZmlsZSB0eXBlIGV4aWYAAHjabVDbDcMwCPxnio7AK36M4zSu1A06frHBVRL1JI6nzhjon/cLHgNMCrrlkmpKaNCqlZsFBR1tMqFO9mT16FoHfEaDrSTmxdOSYn7V6Sfgrlm0nYRKCNF+bVQN/XITYncyNhrxEUI1hIS9QSHQ/FuYasnnL+wdryhuMIgzzTEJ9Xuu2a53bPaOMHchQWMR9QVkmIA0C9SYbQhnsdnQYJV1EzvIvzstwBdYKlmkC+D3bAAAAYRpQ0NQSUNDIHByb2ZpbGUAAHicfZE9SMNAHMVf04oiFQcriohkaJ3soiKOtQpFqBBqhVYdTC79giYNSYuLo+BacPBjserg4qyrg6sgCH6AuLo4KbpIif9LCi1iPDjux7t7j7t3gNAoM80KxABNr5qpRFzMZFfF7lcEMIghjCEiM8uYk6QkPMfXPXx8vYvyLO9zf44+NWcxwCcSx5hhVok3iGc2qwbnfeIQK8oq8TnxhEkXJH7kuuLyG+eCwwLPDJnp1DxxiFgsdLDSwaxoasTTxGFV0ylfyLisct7irJVrrHVP/sJgTl9Z5jrNUSSwiCVIEKGghhLKqCJKq06KhRTtxz38I45fIpdCrhIYORZQgQbZ8YP/we9urfzUpJsUjANdL7b9EQG6d4Fm3ba/j227eQL4n4Erve2vNIDZT9LrbS18BPRvAxfXbU3ZAy53gOEnQzZlR/LTFPJ54P2MvikLDNwCvWtub619nD4AaeoqeQMcHALjBcpe93h3T2dv/55p9fcDuoFywzxfHMMAAA16aVRYdFhNTDpjb20uYWRvYmUueG1wAAAAAAA8P3hwYWNrZXQgYmVnaW49Iu+7vyIgaWQ9Ilc1TTBNcENlaGlIenJlU3pOVGN6a2M5ZCI/Pgo8eDp4bXBtZXRhIHhtbG5zOng9ImFkb2JlOm5zOm1ldGEvIiB4OnhtcHRrPSJYTVAgQ29yZSA0LjQuMC1FeGl2MiI+CiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogIDxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PSIiCiAgICB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIKICAgIHhtbG5zOnN0RXZ0PSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VFdmVudCMiCiAgICB4bWxuczpHSU1QPSJodHRwOi8vd3d3LmdpbXAub3JnL3htcC8iCiAgICB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iCiAgICB4bWxuczp0aWZmPSJodHRwOi8vbnMuYWRvYmUuY29tL3RpZmYvMS4wLyIKICAgIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyIKICAgeG1wTU06RG9jdW1lbnRJRD0iZ2ltcDpkb2NpZDpnaW1wOmViNjRiZjI3LWVmYzEtNDNjOS1iOTA5LTc3NGM5ZDdmNDJhOCIKICAgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDpjY2U1MzgyNi0zZGM4LTRhYjUtOWRjNC02ODI4ZDM0MzMyMDkiCiAgIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDowZjhmY2JjNC1lNDcwLTQ5ZDItYTJkOS0xZWQ2YWI3MDM3YTYiCiAgIEdJTVA6QVBJPSIyLjAiCiAgIEdJTVA6UGxhdGZvcm09Ik1hYyBPUyIKICAgR0lNUDpUaW1lU3RhbXA9IjE2ODIxMTk5NzA0Nzk5MzUiCiAgIEdJTVA6VmVyc2lvbj0iMi4xMC4zNCIKICAgZGM6Rm9ybWF0PSJpbWFnZS9wbmciCiAgIHRpZmY6T3JpZW50YXRpb249IjEiCiAgIHhtcDpDcmVhdG9yVG9vbD0iR0lNUCAyLjEwIgogICB4bXA6TWV0YWRhdGFEYXRlPSIyMDIzOjA0OjIyVDAyOjMyOjQwKzAzOjAwIgogICB4bXA6TW9kaWZ5RGF0ZT0iMjAyMzowNDoyMlQwMjozMjo0MCswMzowMCI+CiAgIDx4bXBNTTpIaXN0b3J5PgogICAgPHJkZjpTZXE+CiAgICAgPHJkZjpsaQogICAgICBzdEV2dDphY3Rpb249InNhdmVkIgogICAgICBzdEV2dDpjaGFuZ2VkPSIvIgogICAgICBzdEV2dDppbnN0YW5jZUlEPSJ4bXAuaWlkOmUxNzBlNjhjLWUyZTAtNDU5Mi04M2FkLTJhZjNjNjEwZTFmMyIKICAgICAgc3RFdnQ6c29mdHdhcmVBZ2VudD0iR2ltcCAyLjEwIChNYWMgT1MpIgogICAgICBzdEV2dDp3aGVuPSIyMDIzLTA0LTIyVDAyOjMyOjUwKzAzOjAwIi8+CiAgICA8L3JkZjpTZXE+CiAgIDwveG1wTU06SGlzdG9yeT4KICA8L3JkZjpEZXNjcmlwdGlvbj4KIDwvcmRmOlJERj4KPC94OnhtcG1ldGE+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAKPD94cGFja2V0IGVuZD0idyI/Pmr8GcAAAAAGYktHRAD/AP8A/6C9p5MAAAAJcEhZcwAACxIAAAsSAdLdfvwAAAAHdElNRQfnBBUXIDIR6EAgAAAC/klEQVQ4y3WUz2tcdRTFP+c7maaTmUmxk4Z5Vesi0oIFa424e+OPCFrRjYq0NVAsbvR/eG+R778gouhKa9WVGAQRq+h7UlyJGGlcSKUifWOSaWRmkmmbzPe6mCnFind1L9x74N5zzhVAlGYCOQOBmUyh8LFFae6KpTg0k8xJWgAeMkwyVoALhW/t3O7JJXAmEyYDQtvHpmaaqb3UMu6IKMnLhY93mkk2D3rHTU7Na7IKgN3cxq5v/WLwetvH30dpXi6W4p07MZpJJo032IuxaNJRsMsyfVT4eKOZZseBrFRt1IZb164KvgKCYQul6v5Dw/61XaHHCh9fjJK8AZwy2RymS8CHbR9vK0qyWRNflKb2P6zyHmy4S+htXAaeAb3lpmeeCt2NZeBM4eO/AZppVsX0XqneOBn6nYsYZw2WS/XGYZUmsN2bhP7mT8CzitLsA1efXQzdtd9AHwPPq1I/ZoPeH8A9hm0KjhS+1Wkm2QSIto93oySvAqtI92J2VZXaQRv0fzZsWehlt2/2cOiuve8MvRB66wBnCx8nwIs26G3hdEiTFQd8W/hWJ0rzUtu3dsfg5cLHW2DfaHIKpINh0OuDnWz7VmLi1dBbB7OnJwAZZsBwRI0NR2IaVUIGYNzWgWmcSIxGxy1oyAgwjCekKM3Ou/qBU6G7/quhT4Q9p0p93gb9P4G7DdsYn2izmWZlGYzlWcFYxek+grVVqTVt0P8R7HPQS27f7AOhu3ZOUZo3gS9drfEgzoEZobtxBTiBeNPVZ54c9tY/xXSm7ePeiOR8r4x3Xb2xGPqdHzBeAz5z0zNzSBACoddZAU6MZZrXMHsFcdRMvwvOFz7+q5lkjwgyV2tUQr9zBfjaRAA9Xqredf+wvzkEnmj7OI+S/ABwGtkcxqqhc20f93TLif9ntCjJHgXeVmX6uPZURmzs3MC2u5cQbxRL8XdRkpUL3/qv0dLc3dpAgDMzRvz9+1VEST4BLCA7BnKYrYAuFD6+ESWZK3wrRMkIAwyTwEav4h8jJo10GPboHQAAAABJRU5ErkJggg==
""")

# TODO description & icons
# TODO timeout option

def main(config):
    # cache check
    free_space_cache = cache.get("free_space")
    mem_free_persent_cache = cache.get("mem_free_persent")
    if free_space_cache != None and mem_free_persent_cache != None:
        free_space = int(free_space_cache)
        mem_free_persent = int(mem_free_persent_cache)
    else:
        CLOUD_FULL_URL = "https://" + config.str("server", "nextcloud.com") + CLOUD_STATUS_URL
        rep = http.get(CLOUD_FULL_URL, headers={"NC-Token": config.str("token", "bad-token")})
        if rep.status_code != 200:
            fail("Cloud request failed with status %d", rep.status_code)

        free_space = int(int(rep.json()["ocs"]["data"]["nextcloud"]["system"]["freespace"])/1000000000)
        cache.set("free_space", str(free_space), ttl_seconds=240)

        mem_total = int(rep.json()["ocs"]["data"]["nextcloud"]["system"]["mem_total"])
        mem_free = int(rep.json()["ocs"]["data"]["nextcloud"]["system"]["mem_free"])
        mem_free_persent = int(mem_free / mem_total * 100)
        cache.set("mem_free_persent", str(mem_free_persent), ttl_seconds=240)

    return render.Root(
        child = render.Box(  # This Box exists to provide vertical centering
            child = render.Column(
                children=[
                    render.Row(
                        expanded=True, # Use as much horizontal space as possible
                        main_align="space_evenly", # Controls horizontal alignment
                        cross_align="center", # Controls vertical alignment
                        children = [
                            render.Image(src=CLOUD_ICON),
                        ],
                    ),
                    render.Row(
                        expanded=True, # Use as much horizontal space as possible
                        main_align="space_evenly", # Controls horizontal alignment
                        cross_align="center", # Controls vertical alignment
                        children = [
                            render.Text(
                                content = "Spc: %s GB" % free_space,
                                font = "5x8",
                            )
                        ],
                    ),
                    render.Row(
                        expanded=True, # Use as much horizontal space as possible
                        main_align="space_evenly", # Controls horizontal alignment
                        cross_align="center", # Controls vertical alignment
                        children = [
                            render.Text(
                                content = "Mem: %s %%" % mem_free_persent,
                                font = "5x8",
                            )
                        ],
                    ),
                ],
            ),
        ),
    )

def get_schema():
    return schema.Schema(
        version = "1",
        fields = [
            schema.Text(
                id = "server",
                name = "Server domain",
                desc = "Domain name of the server with nextcloud",
                icon = "server",
            ),
            schema.Toggle(
                id = "https",
                name = "https?",
                desc = "",
                icon = "compress",
                default = True,
            ),
            schema.Text(
                id = "token",
                name = "Secret token",
                desc = "Secret token",
                icon = "key",
            ),
        ],
    )
