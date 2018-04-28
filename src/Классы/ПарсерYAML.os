#Использовать "./internal/"

Перем ВнутреннийПарсерYAML;

// YAML Парсер
//
// Параметры:
//  Значение - Строка - Строка данных в формате YAML для парсинга;
//
// Возвращаемое значение:
//  Соответсвие - Набор данных согласно содержимому входящих данных. 
//
Функция ПрочитатьYAML(Знач Значение) Экспорт

	Возврат ВнутреннийПарсерYAML.ПрочитатьYAML(Значение);

КонецФункции

// YAML сериализатор
//
// Параметры:
//  Значение - Произвольный - Набор данных сериализуемых в формат;
//
// Возвращаемое значение:
//  Строка - Строка данных в формате YAML согласно содержимому входящих данных. 
//
Функция ЗаписатьYAML(Знач Значение) Экспорт
	
	Возврат ВнутреннийПарсерYAML.ЗаписатьYAML(Значение);

КонецФункции

Процедура ПриСозданииОбъекта()
	
	ВнутреннийПарсерYAML = Новый ВнешнаяяDLL_ПарсерYAML;

КонецПроцедуры