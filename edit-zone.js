var fs = require('fs');

const CONFIG = {
    user: process.env.USER,
    password: process.env.PASSWORD,
    txtRecord: '_acme-challenge',
    challenge: process.env.CHALLENGE
};

var data = fs.readFileSync(0, 'utf-8');
if (!data) process.exit(1);

var zonePos = data.indexOf('<zone>');
if (zonePos < 1) process.exit(2);

var zoneEnd = data.indexOf('</zone>') + 7;
if (zoneEnd < 8) process.exit(3);

data = data.substr(zonePos, zoneEnd - zonePos);

var ocPos = data.indexOf(`<name>${CONFIG.txtRecord}</`);
if (ocPos < 1) process.exit(4);

var valPos = data.indexOf('<value>', ocPos) + 7;
if (valPos < 1) process.exit(5);

var valEnd = data.indexOf('</', valPos);
if (valEnd < 1) process.exit(6);


data = data.substr(0, valPos) + CONFIG.challenge + data.substr(valEnd);
data = data.replace(/\<changed\>[^\<]+\<\/changed\>/, '');
data = data.replace(/\<created\>[^\<]+\<\/created\>/, '');
data = data.replace(/\<owner\>.+\<\/owner\>/, '');
data = data.replace(/\<updated_by\>.+\<\/updated_by\>/, '');
data = `<?xml version="1.0" encoding="utf-8"?>
<request>
    <auth>
        <user>${CONFIG.user}</user>
        <password>${CONFIG.password}</password>
        <context>4</context>
    </auth>
    <task>
        <code>0202</code>
        ${data}
    </task>
</request>`;
console.log(data);
