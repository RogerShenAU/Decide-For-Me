class DropdownList{
  const DropdownList(this.value, this.title);

  final String value;
  final String title;

  List<DropdownList> placeTypeDropdownList(){
    return <DropdownList>[
      const DropdownList('cafe','Cafe'),
      const DropdownList('restaurant','Restaurant'),
      const DropdownList('park','Park'),
    ];
  }

   List<DropdownList> radiusDropdownList(){
    return <DropdownList>[
      const DropdownList('100','100m'),
      const DropdownList('200','200m'),
      const DropdownList('500','500m'),
      const DropdownList('1000','1km'),
      const DropdownList('2000','2km'),
      const DropdownList('3000','3km'),
      const DropdownList('4000','4km'),
      const DropdownList('5000','5km'),
    ];
  }
}