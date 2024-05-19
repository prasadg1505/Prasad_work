#!/bin/ksh

if [[ -z $1 && -z $EMSSRV ]]
then
        echo
        echo "USAGE: $0 <EMS_SERVER>"
        echo
        exit 1
fi

if [[ -z $EMSSRV ]]
then
        EMSSRV=$1
fi

$TIBCO_HOME/ems/bin/tibemsadmin -server "$EMSSRV" -user admin -password admin <<EOF

delete bridge source=topic:OrderManagementCns target=queue:queue.cbr.cns.out
Y
create bridge source=topic:OrderManagementCns target=queue:queue.cbr.cns.out selector="system in ('ALL') and action_name in ('Send draft products to Subscribers','Notify Deactivation PS','Notify Activation PS', 'Active Contract','Notify Activation Technical Option','Notify Deactivation Technical Option','Notify Reactivation Order PS','Notify Suspension Order PS', 'Notify Change Number PS','Notify Change Offer','Notify Switch Order','Notify Change Technical Option','Send draft mobile products','Notify Change SIM', 'Delete Request Mnp','Notify Draft Technical Option','Send Contract Referent','Send draft tech options to Subscribers','Notify Change Class','Start wline provisioning to Subscribers','Send draft for MNP','Notify End Order','Notify KO Consensus','Notify KO from Network')"

delete bridge source=topic:OrderManagementCns target=queue:queue.cfms.cns.out
Y
create bridge source=topic:OrderManagementCns target=queue:queue.cfms.cns.out selector="system in ('ALL') and action_name in ('Send draft products to Subscribers','Notify Deactivation PS','Notify Activation PS','Active Contract','Notify Activation Technical Option','Notify Deactivation Technical Option','Notify Reactivation Order PS','Notify Suspension Order PS', 'Notify Change Number PS', 'Notify Change Offer','Notify Switch Order','Notify Change Technical Option','Notify Change SIM','Notify Activation Equipment','Notify Deactivation Equipment','Send draft mobile products','Send Contract Referent','Notify Activation Commercial Option','Notify Deactivation Commercial Option','Notify Change Class','Start wline provisioning to Subscribers','Notify Cvp OK Result','Notify KO from Network','Notify Cvp KO Result','Notify Change BA wln','Notify Change BA wls')"


delete bridge source=topic:OrderManagementCns target=queue:queue.creso.cns.out
Y
create bridge source=topic:OrderManagementCns target=queue:queue.creso.cns.out selector="system in ('ALL') and action_name in ('Notify Deactivation PS','Notify Activation PS','Active Contract','Notify Reactivation Order PS','Notify Suspension Order PS', 'Notify Change Number PS', 'Notify Change Offer','Notify Switch Order','Notify Change Technical Option','Notify Change Class','Notify Deactivation Technical Option','Notify Activation Technical Option','Notify Change BA wln','Notify Change BA wls')"



exit
EOF

