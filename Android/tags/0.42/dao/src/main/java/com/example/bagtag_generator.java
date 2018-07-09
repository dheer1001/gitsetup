package com.example;

import de.greenrobot.daogenerator.DaoGenerator;
import de.greenrobot.daogenerator.Entity;
import de.greenrobot.daogenerator.Index;
import de.greenrobot.daogenerator.Property;
import de.greenrobot.daogenerator.Schema;

public class bagtag_generator {
    private static final String PROJECT_DIR = System.getProperty("user.dir").replace("\\", "/");
    private static final String OUT_DIR = PROJECT_DIR + "/app/src/main/java";
    public static void main(String args[]) throws Exception {
        Schema schema = new Schema(5, "aero.developer.bagnet.objects");
     addTables(schema);
      new DaoGenerator().generateAll(schema, OUT_DIR);
    }
    private static void addTables(Schema schema) {
        Entity task = addBagTag(schema);
    }
    private static Entity addBagTag(Schema schema) {
        Entity bagTag = schema.addEntity("BagTag");
        bagTag.addIdProperty().primaryKey().autoincrement();
        bagTag.setTableName("BagTag");
        bagTag.setHasKeepSections(true);
        bagTag.setConstructors(true);
        bagTag.addStringProperty("datetime");
        Property property1= bagTag.addStringProperty("trackingpoint").getProperty();
        Property property=bagTag.addStringProperty("containerid").getProperty();
        Property property2 = bagTag.addStringProperty("bagtag").getProperty();
        bagTag.addStringProperty("flightnum");
        bagTag.addStringProperty("flighttype");
        bagTag.addStringProperty("flightdate");
        bagTag.addBooleanProperty("synced");
        bagTag.addBooleanProperty("locked");
        bagTag.addStringProperty("errorMsg");
        bagTag.addStringProperty("pnr");
        bagTag.addStringProperty("passenger_last_name");
        bagTag.addStringProperty("passenger_first_name");
        bagTag.addStringProperty("inbound_airline_code");
        bagTag.addStringProperty("inbound_flight_date");
        bagTag.addStringProperty("origin_airport");
        bagTag.addStringProperty("outbound_airline_code");
        bagTag.addStringProperty("outbound_flight_date");
        bagTag.addStringProperty("destination_airport");
        bagTag.addStringProperty("inbound_flight_num");
        bagTag.addStringProperty("outbound_flight_num");
        Index index = new Index();
        index.addProperty(property1);
        index.addProperty(property2);
        index.addProperty(property);
        index.makeUnique();
        bagTag.addIndex(index);

        return bagTag;
    }


}
