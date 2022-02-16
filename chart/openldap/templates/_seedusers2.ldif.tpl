# Add Group OU
dn: ou=Groups{{with .Values.ldap.domain | split "."}}{{range .}},dc={{.}}{{end}}{{end}}
changetype: add
objectclass: organizationalUnit
ou: Groups

# Add People OU
dn: ou=People{{with .Values.ldap.domain | split "."}}{{range .}},dc={{.}}{{end}}{{end}}
changetype: add
objectclass: organizationalUnit
ou: People

# Add users
{{- $domain := .Values.ldap.domain }}
{{- $initialPassword := .Values.seedusers.initialpassword }}
{{- with .Values.seedusers.userlist | split ","}}
  {{- range . }}
dn: uid={{.}},ou=People{{with $domain | split "."}}{{range .}},dc={{.}}{{end}}{{end}}
changetype: add
objectclass: inetOrgPerson
objectclass: organizationalPerson
objectclass: person
objectclass: top
uid: {{.}}
displayname: {{.}}
sn: {{.}}
cn: {{.}}
userpassword: {{ printf $initialPassword }}
{{ end }}
{{- end }}

# Create ICP user group
dn: cn={{.Values.seedusers.usergroup}},ou=Groups{{with .Values.ldap.domain | split "."}}{{range .}},dc={{.}}{{end}}{{end}}
changetype: add
cn: {{.Values.seedusers.usergroup}}
objectclass: groupOfUniqueNames
objectclass: top
owner: cn=admin{{with .Values.ldap.domain | split "."}}{{range .}},dc={{.}}{{end}}{{end}}
{{- with .Values.seedusers.userlist | split ","}}
  {{- range . }}
uniquemember: uid={{.}},ou=People{{with $domain | split "."}}{{range .}},dc={{.}}{{end}}{{end}}
  {{- end}}
{{- end}}
