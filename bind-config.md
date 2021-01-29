# Bind dynamic DNS configuration

1. Run `ddns-confgen`

        # To activate this key, place the following in named.conf, and
        # in a separate keyfile on the system or systems from which nsupdate
        # will be run:
        key "ddns-key" {
                algorithm hmac-sha256;
                secret "lNct/dhnEUk7ZCWYGNA2x6vd7lBP88KHI7VWLOHivrc=";
        };

        # Then, in the "zone" statement for each zone you wish to dynamically
        # update, place an "update-policy" statement granting update permission
        # to this key.  For example, the following statement grants this key
        # permission to update any name within the zone:
        update-policy {
                grant ddns-key zonesub ANY;
        };

        # After the keyfile has been placed, the following command will
        # execute nsupdate using this key:
        nsupdate -k <keyfile>

2. Create `/etc/named/keys.conf` (replace `ddns-key` with a FQDN name):

        key "ddns-key.example.org." {
                algorithm hmac-sha256;
                secret "lNct/dhnEUk7ZCWYGNA2x6vd7lBP88KHI7VWLOHivrc=";
        };

3. Configure forward & reverse zones in `/etc/named/named.conf`

        ////
        // example.org
        //

        include "/etc/named/keys.conf";

        zone "example.org" IN {
            type master;
            file "example.org.zone";
            update-policy { grant ddns-key.example.org. zonesub ANY; };
        };

        zone "0.0.127.in-addr.arpa" IN {  // 127.0.0.0/24
            type master;
            file "0.0.127.in-addr.arpa.zone";
            update-policy { grant ddns-key.example.org. zonesub ANY; };
        };


4. Create forward zone (use `/var/named/localhost.zone` as an example):

        $TTL    86400
        $ORIGIN example.org.
        @            1D IN SOA    @ root (
                            42        ; serial (d. adams)
                            3H        ; refresh
                            15M        ; retry
                            1W        ; expiry
                            1D )        ; minimum

                    1D IN NS    @
                    1D IN A        127.0.0.1



5. Create reverse zone (use `/var/named/localhost.zone` as an example):

        $TTL    86400
        $ORIGIN 0.0.0.127.in-addr.arpa.
        @            1D IN SOA    @ root (
                            42        ; serial (d. adams)
                            3H        ; refresh
                            15M        ; retry
                            1W        ; expiry
                            1D )        ; minimum

                    1D IN NS    @
                    1D IN A        127.0.0.1



6. Test with `nsupdate` and `dig`

        $ nsupdate -p PORT -k KEYFILE
        server 127.0.0.1
        zone example.org
        update add demo 300 IN A 127.0.0.1
        send
        zone 0.0.127.in-addr.arpa
        update add 1 300 IN PTR example.org
        send
        ^C

        $ dig -p PORT @127.0.0.1 A demo.example.org

        $ dig -p PORT @127.0.0.1 -x 127.0.0.1