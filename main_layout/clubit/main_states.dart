abstract class MainStates {}

class MainInitialState extends MainStates {}

class GetDataLoadingState extends MainStates {}
class GetDataSuccessState extends MainStates {}
class GetDataErrorState extends MainStates {}

class InsertDataLoadingState extends MainStates {}
class InsertDataSuccessState extends MainStates {}
class InsertDataErrorState extends MainStates {}