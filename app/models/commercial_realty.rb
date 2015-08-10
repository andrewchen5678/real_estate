#encoding: utf-8
class CommercialRealty < ActiveRecord::Base
    REALTY_TYPE_DESC=ActiveSupport::OrderedHash['CShop','商業店面/餐廳',
      'COffice','辦公大樓',
      'CWareHouse','倉庫/廠房',
      'CLand','土地'
    ]

  INSIDE_COMPONENT_DESC=ActiveSupport::OrderedHash[1,'廁所',
      2,'廚房/茶水室',
      3,'會議室/會客室',
      4,'獨立辦公室',
      5,'大廳'
    ]

  PUBLIC_FACILITY_DESC=ActiveSupport::OrderedHash[1,'殘障人士車位',
      2,'輪椅斜坡',
      3,'代客泊車',
      4,'保安人員',
      5,'公共大廳',
      6,'公共會議室',
      7,'兒童遊戲區'
    ]

    include RealtyCommon
    define_int_array_setters :inside_component,:public_facility

    validates_inclusion_of :realty_type, :in => REALTY_TYPE_DESC.keys
    
end
