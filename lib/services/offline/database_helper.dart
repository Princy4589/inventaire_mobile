import 'package:path/path.dart';
import 'package:pgi_mobile/models/affected_to.dart';
import 'package:pgi_mobile/models/code_immo.dart';
import 'package:pgi_mobile/models/direction.dart';
import 'package:pgi_mobile/models/history_affectation.dart';
import 'package:pgi_mobile/models/history_stock.dart';
import 'package:pgi_mobile/models/immo_state.dart';
import 'package:pgi_mobile/models/log.dart';
import 'package:pgi_mobile/models/person.dart';
import 'package:pgi_mobile/models/seats.dart';
import 'package:pgi_mobile/models/services.dart';
import 'package:pgi_mobile/models/sex.dart';
import 'package:pgi_mobile/models/storage_address.dart';
import 'package:pgi_mobile/models/traceability_service.dart';
import 'package:pgi_mobile/models/user.dart';
import 'package:pgi_mobile/models/user_affected.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqflite_dev.dart';

//classe qui va permettre d'insérer, récupérer les données obtenues du serveur
class Provider {
  static Database? db;
  String dbpath = "database.db";

  //FOnction qui initialise la base de données
  Future initDB() async {
    await databaseFactory.setLogLevel(sqfliteLogLevelVerbose);
    db = await openDatabase(
      join(await getDatabasesPath(), dbpath),
      onCreate: (db, version) => createTable(db),
      version: 1,
    );
    return db;
  }

  //Création des tables à la connexion à l'application
  static void createTable(Database db) {
    db.execute('''
        CREATE TABLE IF NOT EXISTS code_immo (
          code_immo_id   INTEGER       PRIMARY KEY,
          code_immo_code VARCHAR (255) NOT NULL,
          name           VARCHAR (255) NOT NULL,
          code_name      VARCHAR (4)   NOT NULL,
          acquis_value   VARCHAR       NOT NULL,
          date_acquis    DATE          NOT NULL,
          funding        INTEGER       NOT NULL,
          direction      INTEGER       NOT NULL,
          number_ordre   VARCHAR (4)   NOT NULL,
          isExtrat       INTEGER (1)   NOT NULL
        );
      ''');
    db.execute('''
        CREATE TABLE IF NOT EXISTS user (
          user_id             INTEGER       PRIMARY KEY,
          email               VARCHAR (255),
          hash                VARCHAR (60)  DEFAULT NULL,
          create_time         DATETIME,
          person_id           INTEGER       DEFAULT NULL,
          is_active           TINYINT (1)   DEFAULT 1,
          registration_number VARCHAR (50)  DEFAULT NULL,
          name_image          VARCHAR (255) DEFAULT NULL,
          nif                VARCHAR (255) DEFAULT NULL,
          stat               VARCHAR (255) DEFAULT NULL,
          office_number       VARCHAR (50),
          phone_number        VARCHAR (50)  DEFAULT NULL,
          emergency_phone     VARCHAR (255) DEFAULT NULL,
          CONSTRAINT fk_user_person1 FOREIGN KEY (
            person_id
            ) REFERENCES person (person_id)
        );

      ''');
    db.execute('''
        CREATE TABLE IF NOT EXISTS direction (
          direction_id        INTEGER      NOT NULL
                                          PRIMARY KEY,
          type                VARCHAR (50) NOT NULL,
          description         TEXT         NOT NULL,
          direction_parent_id INTEGER      DEFAULT NULL,
          code                VARCHAR (45) DEFAULT NULL,
          name                VARCHAR (45) DEFAULT NULL
    
        );
      ''');
    db.execute(''' 
      CREATE TABLE IF NOT EXISTS service (
        service_id   INTEGER      NOT NULL
                                  PRIMARY KEY,
        direction_id INTEGER      NOT NULL
                                  DEFAULT 0,
        name         VARCHAR (255) NOT NULL,
        code         VARCHAR (20)  NOT NULL,
        description  TINYTEXT      DEFAULT NULL,
        UNIQUE (
            code
        ),
        CONSTRAINT service_ibfk_1 FOREIGN KEY (
            direction_id
        )
        REFERENCES direction (direction_id) 
    );
    ''');
    db.execute('''
      CREATE TABLE IF NOT EXISTS seats (
        seat_id      INTEGER           NOT NULL,
        seat_name    VARCHAR (255) NOT NULL,
        direction_id INTEGER           NOT NULL,
        PRIMARY KEY (
            seat_id
        ),
        CONSTRAINT fk_seat_direction1 FOREIGN KEY (
            direction_id
        )
        REFERENCES direction (direction_id) 
    );
    ''');
    db.execute('''
      CREATE TABLE IF NOT EXISTS storage_address (
        storage_id      INTEGER           NOT NULL,
        storage_address VARCHAR (255),
        seat_id         INTEGER           NOT NULL,
        PRIMARY KEY (
            storage_id
        ),
        CONSTRAINT fk_storage_address_seat1 FOREIGN KEY (
            seat_id
        )
        REFERENCES Seats (seat_id)
    );
    ''');
    db.execute('''
      CREATE TABLE IF NOT EXISTS sex (
        sex_id INTEGER (11) NOT NULL,
        name   VARCHAR (45) NOT NULL,
        PRIMARY KEY (
            sex_id
          )
    );
    ''');
    db.execute('''
      CREATE TABLE IF NOT EXISTS person (
        person_id              INTEGER       NOT NULL,
        first_name             VARCHAR (255) DEFAULT NULL,
        last_name              VARCHAR (255) NOT NULL,
        personnal_email        VARCHAR (255) DEFAULT NULL,
        card_number            VARCHAR (45)  DEFAULT NULL,
        card_date              DATE          DEFAULT NULL,
        birth_date             DATE          DEFAULT NULL,
        telephone              VARCHAR (15)  DEFAULT NULL,
        sex_id                 INTEGER       NOT NULL,
        card_deliverance_date  DATE          DEFAULT NULL,
        birth_place            VARCHAR (255) DEFAULT NULL,
        card_deliverance_place VARCHAR (255) DEFAULT NULL,
        number_child           INT (11)      DEFAULT NULL,
        address                VARCHAR (255) DEFAULT NULL,
        marital_status         VARCHAR (50)  DEFAULT NULL,
        card_duplicate_date    DATE          DEFAULT NULL,
        PRIMARY KEY (
            person_id
        ),
        CONSTRAINT fk_person_sex1 FOREIGN KEY (
            sex_id
        )
        REFERENCES sex (sex_id)
    );
    ''');
    db.execute('''
      CREATE TABLE IF NOT EXISTS ImmoState (
        immoStateId  INTEGER      NOT NULL
                                  PRIMARY KEY ASC AUTOINCREMENT,
        state        VARCHAR (20) CHECK (state IN ('BON ETAT','MAUVAIS ETAT','ETAT MOYEN','TRES BON ETAT') ) 
                                  NOT NULL
                                  DEFAULT 'BON ETAT',
        modifiedTime DATE         NOT NULL,
        code_immo_id INTEGER          NOT NULL,
        
        CONSTRAINT fk_Immo_state_code_immo1 FOREIGN KEY (
            code_immo_id
        )
        REFERENCES code_immo (code_immo_id) 
    );
    ''');
    db.execute('''
      CREATE TABLE IF NOT EXISTS traceability_service (
        traceability_service_id INTEGER  NOT NULL
                                        PRIMARY KEY,
        user_id                 INTEGER NOT NULL,
        service_id              INTEGER NOT NULL,
        start_time              DATE     NOT NULL,
        end_time                DATE     DEFAULT NULL,
        CONSTRAINT fk_traceability_service_service1 FOREIGN KEY (
            service_id
        )
        REFERENCES service (service_id),
        CONSTRAINT fk_traceability_service_user1 FOREIGN KEY (
            user_id
        )
        REFERENCES user (user_id) 
    );

    ''');
    db.execute('''
      CREATE TABLE affectedto (
        affectedTo_id INTEGER NOT NULL
                              PRIMARY KEY AUTOINCREMENT,
        added_time    DATE    DEFAULT NULL,
        code_immo_id  INTEGER NOT NULL,
        user_id       INTEGER NOT NULL,
        UNIQUE(
          code_immo_id
        ),
        CONSTRAINT fk_AffectedTo_code_immo1 FOREIGN KEY (
            code_immo_id
        )
        REFERENCES code_immo (code_immo_id),
        CONSTRAINT fk_AffectedTo_user1 FOREIGN KEY (
            user_id
        )
        REFERENCES person (person_id) 
    );
    ''');
    db.execute('''
      CREATE TABLE History_Affected_Material_Inventory (
        history_id        INTEGER  NOT NULL
                                  PRIMARY KEY AUTOINCREMENT,
        time_of_operation DATETIME,
        code_immo_id      INTEGER  NOT NULL,
        direction_id      INTEGER  NOT NULL,
        immoStateId       INTEGER  NOT NULL,
        user_id           INTEGER  NOT NULL,
        person_id         INTEGER  NOT NULL,
        observation       TEXT DEFAULT NULL,

        CONSTRAINT fk_history_Affected_Material_Inventory_code_immo1 FOREIGN KEY (
            code_immo_id
        )
        REFERENCES code_immo (code_immo_id),
        CONSTRAINT fk_Affected_Material_Inventory_direction1 FOREIGN KEY (
            direction_id
        )
        REFERENCES direction (direction_id),
        CONSTRAINT fk_Affected_Material_Inventory_state1 FOREIGN KEY (
            immoStateId
        )
        REFERENCES immostate (immoStateId),
        CONSTRAINT fk_Affected_Material_Inventory_user1 FOREIGN KEY (
            user_id
        )
        REFERENCES user (user_id),
        CONSTRAINT fk_Affected_Material_Inventory_person1 FOREIGN KEY (
            person_id
        )
        REFERENCES person (person_id) 
    );

    ''');
    db.execute('''
      CREATE TABLE IF NOT EXISTS History_Stock_Inventory (
        history_id        INTEGER  NOT NULL
                                  PRIMARY KEY AUTOINCREMENT,
        time_of_operation DATETIME,
        code_immo_id      INTEGER  NOT NULL,
        direction_id      INTEGER  NOT NULL,
        immoStateId       INTEGER  NOT NULL,
        user_id           INTEGER  NOT NULL,
        storage_id        INTEGER  NOT NULL,
        observation       TEXT DEFAULT NULL,

        CONSTRAINT fk_history_stock_inventory_code_immo1 FOREIGN KEY (
            code_immo_id
        )
        REFERENCES code_immo (code_immo_id),
        CONSTRAINT fk_history_stock_inventory_direction1 FOREIGN KEY (
            direction_id
        )
        REFERENCES direction (direction_id),
        CONSTRAINT fk_history_stock_inventory_state1 FOREIGN KEY (
            immoStateId
        )
        REFERENCES immostate (immoStateId),
        CONSTRAINT fk_history_stock_inventory_user1 FOREIGN KEY (
            user_id
        )
        REFERENCES user (user_id),
        CONSTRAINT fk_history_stock_inventory_storage1 FOREIGN KEY (
            storage_id
        )
        REFERENCES storage_address (storage_id) 
    );
    ''');
    db.execute('''
      CREATE TABLE IF NOT EXISTS log (
        id  INTEGER PRIMARY KEY ASC AUTOINCREMENT,
        email VARCHAR (255) NOT NULL,
        password VARCHAR (255) NOT NULL,
        user_id INTEGER NOT NULL
      )
    ''');
  }

  //Liste de fonction future qui va récupérer les données venant de la
  //base de données locale sqlite - code_immo
  Future<List<CodeImmo>> getImmoFromDB() async {
    final db = await initDB();
    List<Map<String, dynamic>> maps = [];
    await db.transaction((txn) async {
      maps = await txn.rawQuery('SELECT * from code_immo');
    });

    return List.generate(maps.length, (i) {
      return CodeImmo(
        codeImmoId: maps[i]["code_immo_id"],
        codeImmoCode: maps[i]["code_immo_code"],
        name: maps[i]["name"],
        codeName: maps[i]["code_name"],
        acquisValue: maps[i]["acquis_value"],
        dateAcquis: maps[i]["date_acquis"],
        funding: maps[i]["funding"],
        direction: maps[i]["direction"],
        numberOrdre: maps[i]["number_ordre"],
        isExtrat: maps[i]["isExtrat"],
      );
    });
  }

  Future<List<Affectedto>> getAffectationFromDB() async {
    final db = await initDB();
    List<Map<String, dynamic>> maps = [];
    await db.transaction((txn) async {
      maps = await txn.rawQuery('SELECT * from affectedto');
    });

    return List.generate(maps.length, (i) {
      return Affectedto(
        affectedToId: maps[i]["affectedTo_id"],
        addedTime: maps[i]["added_time"],
        codeImmoId: maps[i]["code_immo_id"],
        userId: maps[i]["user_id"],
      );
    });
  }

  Future<List<Map<String, dynamic>>> getImmoAffectationInfoFromDB(
      immoId) async {
    final db = await initDB();
    List<Map<String, dynamic>> maps = [];
    await db.transaction((txn) async {
      maps = await txn.rawQuery('''
      SELECT max(history_affected_material_inventory.time_of_operation) as 'date',history_id as 'id',direction.name as 'name',
        code_immo.code_immo_code as 'code', immostate.state as 'état', code_immo.name as'matériel',
        person.last_name as 'nom' ,person.first_name as 'prenom'
        FROM `history_affected_material_inventory`
        INNER jOIN direction ON history_affected_material_inventory.direction_id = direction.direction_id
        LEFT JOIN code_immo ON history_affected_material_inventory.code_immo_id = code_immo.code_immo_id
        LEFT jOIN immostate ON history_affected_material_inventory.immoStateId = immostate.immoStateId
        LEFT JOIN affectedto ON history_affected_material_inventory.user_id = affectedto.user_id
        LEFT JOIN person ON history_affected_material_inventory.person_id = person.person_id
        where code_immo.code_immo_id =? AND (SELECT count(affectedto.user_id) from affectedto )>0 
    ''', [immoId]);
    });

    for (var element in maps) {
      if (maps.isNotEmpty &&
          (element["matériel"] != null || element["matériel"] != "null")) {
        return maps;
      } else {
        return [];
      }
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getImmoStockInfoFromDB(immoId) async {
    final db = await initDB();
    List<Map<String, dynamic>> maps = [];
    await db.transaction((txn) async {
      maps = await txn.rawQuery('''
      SELECT max(history_stock_inventory.time_of_operation) as 'date',history_id as 'id',direction.name as 'name',
        code_immo.code_immo_code as 'code', immostate.state as 'état', code_immo.name as 'matériel',
        storage_address.storage_address as 'adresse'
        FROM `history_stock_inventory`
        jOIN direction ON history_stock_inventory.direction_id = direction.direction_id
        JOIN code_immo ON history_stock_inventory.code_immo_id = code_immo.code_immo_id
         jOIN immostate ON history_stock_inventory.immoStateId = immostate.immoStateId
         JOIN storage_address ON history_stock_inventory.storage_id = storage_address.storage_id
        where code_immo.code_immo_id =? AND (SELECT count(storage_address.storage_address) from storage_address)>0
    ''', [immoId]);
    });
    for (var element in maps) {
      if (maps.isNotEmpty &&
          (element["matériel"] != null || element["matériel"] != "null")) {
        return maps;
      } else {
        return [];
      }
    }
    return [];
  }

  /* 

SELECT max(history_stock_inventory.time_of_operation) as 'date',direction.name as 'name',
        code_immo.code_immo_code as 'code', immostate.state as 'état', code_immo.name as 'matériel',
        storage_address.storage_address as 'adresse'
        FROM `history_stock_inventory`
        jOIN direction ON history_stock_inventory.direction_id = direction.direction_id
        JOIN code_immo ON history_stock_inventory.code_immo_id = code_immo.code_immo_id
         jOIN immostate ON history_stock_inventory.immoStateId = immostate.immoStateId
         JOIN storage_address ON history_stock_inventory.storage_id = storage_address.storage_id
        where code_immo.code_immo_id =6647 AND (SELECT count(storage_address.storage_address) from storage_address)>0
  
  */

  Future<List<Historyaffectation>> getHistoryAffectationFromDB() async {
    final db = await initDB();
    List<Map<String, dynamic>> maps = [];
    await db.transaction((txn) async {
      maps = await txn
          .rawQuery('SELECT * from History_Affected_Material_Inventory');
    });

    return List.generate(maps.length, (i) {
      return Historyaffectation(
        historyId: maps[i]["history_id"],
        timeOfOperation: DateTime.parse(maps[i]["time_of_operation"]),
        codeImmoId: maps[i]["code_immo_id"],
        directionId: maps[i]["direction_id"],
        immoStateId: maps[i]["immoStateId"],
        userId: maps[i]["user_id"],
        personId: maps[i]["person_id"],
        observation: maps[i]["observation"],
      );
    });
  }

  Future<List<Historyaffectation>> searchByIdHistoryAffectationFromDB(
      immoId) async {
    final db = await initDB();
    List<Map<String, dynamic>> maps = [];
    await db.transaction((txn) async {
      maps = await txn.rawQuery(
          """SELECT * from History_Affected_Material_Inventory 
          where code_immo_id=? AND (SELECT max(time_of_operation) from history_affected_material_inventory)""",
          [immoId]);
    });

    return List.generate(maps.length, (i) {
      return Historyaffectation(
        historyId: maps[i]["history_id"],
        timeOfOperation: DateTime.parse(maps[i]["time_of_operation"]),
        codeImmoId: maps[i]["code_immo_id"],
        directionId: maps[i]["direction_id"],
        immoStateId: maps[i]["immoStateId"],
        userId: maps[i]["user_id"],
        personId: maps[i]["person_id"],
        observation: maps[i]["observation"],
      );
    });
  }

  Future<List<Log>> getLastLogFromDB() async {
    final db = await initDB();
    List<Map<String, dynamic>> maps = [];
    await db.transaction((txn) async {
      maps = await txn.rawQuery('''
        SELECT * 
        from log
        ORDER BY id DESC
        LIMIT 1''');
    });

    return List.generate(maps.length, (i) {
      return Log(
        id: maps[i]["id"],
        email: maps[i]["email"],
        password: maps[i]["password"],
        userId: maps[i]["user_id"],
      );
    });
  }

  Future<List<Map<String, dynamic>>> getHistoryAffectationViewFromDB() async {
    final db = await initDB();
    List<Map<String, dynamic>> maps = [];
    await db.transaction((txn) async {
      maps = await txn.rawQuery("""
    SELECT History_Affected_Material_Inventory.time_of_operation as 'date',
      code_immo.code_immo_code as 'CODE IMMO', direction.code as 'Direction',
      immostate.state as 'Etat Matériel', user.email as 'email',
      person.last_name as 'person', 
      History_Affected_Material_Inventory.observation as 'observation'
      FROM History_Affected_Material_Inventory INNER JOIN code_immo
      ON History_Affected_Material_Inventory.code_immo_id = code_immo.code_immo_id
      LEFT JOIN direction ON History_Affected_Material_Inventory.direction_id = direction.direction_id
      LEFT JOIN immostate ON History_Affected_Material_Inventory.immoStateId = immostate.immoStateId
      LEFT JOIN person ON History_Affected_Material_Inventory.person_id = person.person_id
      LEFT JOIN user ON History_Affected_Material_Inventory.user_id = user.user_id
    """);
    });

    return maps;
  }

  Future<List<Map<String, dynamic>>> getHistoryStockViewFromDB() async {
    final db = await initDB();
    List<Map<String, dynamic>> maps = [];
    await db.transaction((txn) async {
      maps = await txn.rawQuery("""
    SELECT History_Stock_Inventory.time_of_operation as 'date',
      code_immo.code_immo_code as 'CODE IMMO', direction.code as 'Direction', 
      ImmoState.state as 'Etat Matériel', user.email as 'email', 
      storage_address.storage_address as 'Adresse de stockage',
      History_Stock_Inventory.observation as 'observation'
      FROM History_Stock_Inventory INNER JOIN code_immo
      ON History_Stock_Inventory.code_immo_id = code_immo.code_immo_id
      LEFT JOIN direction ON History_Stock_Inventory.direction_id = direction.direction_id
      LEFT JOIN ImmoState ON History_Stock_Inventory.immoStateId = ImmoState.immoStateId
      LEFT JOIN storage_address ON History_Stock_Inventory.storage_id = storage_address.storage_id
      LEFT JOIN user ON History_Stock_Inventory.user_id = user.user_id
    """);
    });

    return maps;
  }

  Future<List<Historystock>> getHistoryStockFromDB() async {
    final db = await initDB();

    List<Map<String, dynamic>> maps = [];
    await db.transaction((txn) async {
      maps = await txn.rawQuery('SELECT * from History_Stock_Inventory');
    });

    return List.generate(maps.length, (i) {
      return Historystock(
        historyId: maps[i]["history_id"],
        timeOfOperation: DateTime.parse(maps[i]["time_of_operation"]),
        codeImmoId: maps[i]["code_immo_id"],
        directionId: maps[i]["direction_id"],
        immoStateId: maps[i]["immoStateId"],
        userId: maps[i]["user_id"],
        storageId: maps[i]["storage_id"],
        observation: maps[i]["observation"],
      );
    });
  }

  Future<List<TraceabilityService>> getTraceabilityServiceFromDB() async {
    final db = await initDB();

    List<Map<String, dynamic>> maps = [];
    await db.transaction((txn) async {
      maps = await txn.rawQuery('SELECT * from traceability_service');
    });

    return List.generate(maps.length, (i) {
      return TraceabilityService(
        traceabilityServiceId: maps[i]["traceability_service_id"],
        userId: maps[i]["user_id"],
        serviceId: maps[i]["service_id"],
        startTime: maps[i]["start_time"],
        endTime: maps[i]["end_time"],
      );
    });
  }

  Future<List<Sex>> getGenreFromDB() async {
    final db = await initDB();
    List<Map<String, dynamic>> maps = [];
    await db.transaction((txn) async {
      maps = await txn.rawQuery('SELECT * from sex');
    });

    return List.generate(maps.length, (i) {
      return Sex(
        sexId: maps[i]["sex_id"],
        name: maps[i]["name"],
      );
    });
  }

  Future<List<ImmoState>> getStateFromDB() async {
    final db = await initDB();
    List<Map<String, dynamic>> maps = [];
    await db.transaction((txn) async {
      maps = await txn.rawQuery('SELECT * from ImmoState');
    });

    return List.generate(maps.length, (i) {
      return ImmoState(
        immoStateId: maps[i]["immoStateId"],
        state: maps[i]["state"],
        modifiedTime: maps[i]["modifiedTime"],
        codeImmoId: maps[i]["code_immo_id"],
      );
    });
  }

  Future<List<UsersAffected>> getUsersAffectedFromDB() async {
    final db = await initDB();
    List<Map<String, dynamic>> maps = [];
    await db.transaction((txn) async {
      maps = await txn.rawQuery('SELECT * from users');
    });

    return List.generate(maps.length, (i) {
      return UsersAffected(
        personId: maps[i]['person_id'],
        firstName: maps[i]["first_name"],
        lastName: maps[i]["last_name"],
        cin: maps[i]["cin"],
        dateCin: maps[i]["date_cin"],
        lieuCin: maps[i]["lieu_cin"],
        datepCin: maps[i]["datep_cin"],
        ddn: maps[i]["ddn"],
        adresse: maps[i]["adresse"],
        userId: maps[i]["user_id"],
        nameImage: maps[i]["name_image"],
        matricule: maps[i]["matricule"],
        personnalEmail: maps[i]["personnal_email"],
        bureau: maps[i]["bureau"],
        flotte: maps[i]["flotte"],
        urgence: maps[i]["urgence"],
        service: maps[i]["service"],
        porte: maps[i]["porte"],
        seat: maps[i]["seat"],
        dir: maps[i]["dir"],
        type: maps[i]["type"],
      );
    });
  }

  Future<List<Person>> getPersonFromDB() async {
    final db = await initDB();
    List<Map<String, dynamic>> maps = [];
    await db.transaction((txn) async {
      maps = await txn.rawQuery('SELECT * from person');
    });

    return List.generate(maps.length, (i) {
      return Person(
        personId: maps[i]["person_id"],
        firstName: maps[i]["first_name"],
        lastName: maps[i]["last_name"],
        personnalEmail: maps[i]["personnal_email"],
        cardNumber: maps[i]["card_number"],
        cardDate: maps[i]["card_date"],
        birthDate: maps[i]["birth_date"] ?? "null",
        telephone: maps[i]["telephone"],
        sexId: maps[i]["sex_id"],
        cardDeliveranceDate: maps[i]["card_deliverance_date"] ?? "null",
        birthPlace: maps[i]["birth_place"],
        cardDeliverancePlace: maps[i]["card_deliverance_place"],
        numberChild: maps[i]["number_child"],
        address: maps[i]["address"],
        maritalStatus: maps[i]["marital_status"],
        cardDuplicateDate: maps[i]["card_duplicate_date"] ?? "null",
      );
    });
  }

  Future<List<User>> getUsersFromDB() async {
    final db = await initDB();
    List<Map<String, dynamic>> maps = [];

    await db.transaction((txn) async {
      maps = await txn.rawQuery('SELECT * from user');
    });

    return List.generate(maps.length, (i) {
      return User(
        userId: maps[i]["user_id"],
        email: maps[i]["email"],
        hash: maps[i]["hash"],
        createTime: DateTime.parse(maps[i]["create_time"]),
        personId: maps[i]["person_id"],
        isActive: maps[i]["is_active"],
        registrationNumber: maps[i]["registration_number"],
        nameImage: maps[i]["name_image"],
        nif: maps[i]["nif"],
        stat: maps[i]["stat"],
        officeNumber: maps[i]["office_number"],
        phoneNumber: maps[i]["phone_number"],
        emergencyPhone: maps[i]["emergency_phone"],
      );
    });
  }

// fetch Direction from local database
  Future<List<Direction>> getDirectionsFromDB() async {
    final db = await initDB();
    List<Map<String, dynamic>> maps = [];

    await db.transaction((txn) async {
      maps = await txn.rawQuery('SELECT * from direction');
    });

    return List.generate(maps.length, (i) {
      return Direction(
        directionId: maps[i]["direction_id"],
        type: maps[i]["type"],
        description: maps[i]["description"],
        directionParentId: maps[i]["direction_parent_id"],
        code: maps[i]["code"],
        name: maps[i]["name"],
      );
    });
  }

  Future<List<Service>> getServicesFromDB() async {
    final db = await initDB();
    List<Map<String, dynamic>> maps = [];

    await db.transaction((txn) async {
      maps = await txn.rawQuery('SELECT * from service');
    });

    return List.generate(maps.length, (i) {
      return Service(
        serviceId: maps[i]["service_id"],
        directionId: maps[i]["direction_id"],
        name: maps[i]["name"],
        code: maps[i]["code"],
        description: maps[i]["description"],
      );
    });
  }

  Future<List<Seat>> getSeatsFromDB() async {
    final db = await initDB();
    List<Map<String, dynamic>> maps = [];

    await db.transaction((txn) async {
      maps = await txn.rawQuery('SELECT * from seats');
    });

    return List.generate(maps.length, (i) {
      return Seat(
        seatId: maps[i]["seat_id"],
        seatName: maps[i]["seat_name"],
        directionId: maps[i]["direction_id"],
      );
    });
  }

  Future<List<StorageAddress>> getStorageFromDB() async {
    final db = await initDB();
    List<Map<String, dynamic>> maps = [];

    await db.transaction((txn) async {
      maps = await txn.rawQuery('SELECT * from storage_address');
    });

    return List.generate(maps.length, (i) {
      return StorageAddress(
        storageId: maps[i]["storage_id"],
        storageAddress: maps[i]["storage_address"],
        seatId: maps[i]["seat_id"],
      );
    });
  }

  Future<List<dynamic>> insert(dynamic type, String table) async {
    final db = await initDB();
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var element in type) {
        await batch.insert(table, element.toMap(),
            conflictAlgorithm: ConflictAlgorithm.ignore);
      }
      await batch.commit(noResult: true);
    });
    return type;
  }
}
