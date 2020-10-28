local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("ElvUI", "ruRU")
if not L then return end

-- Actionbars
L["Allows you to choose the color of the actionbar button when it is pushed down."] = "Позволяет изменять цвет кнопок панелей команд во время нажатия."
L["Allows you to make actionbars clickthrough."] = "Позволяет совершать нажатия мыши сквозь панели команд."
L["Changes the minimum and maximum allowed actionbar button spacing."] = true;

-- Bags
L["Allows you to change bag buttons to use the classic texture style and allows you to add a 'Stack' button."] = "Позволяет изменять кнопки сумок на текстурные полосы, а так же добавляет кнопку 'Собрать'."
L["Add 'Stack' Button"] = "Добавить кнопку 'Собрать'"
L["Button Color"] = "Цвет кнопок"
L["Button Style"] = "Стиль кнопок"
L["Hold Shift:"] = "Зажмите Shift"
L["Icons"] = "Иконки"
L["Stack Items In Bags"] = "Собрать вещи в сумках"
L["Stack Items In Bank"] = "Собрать вещи в банке"
L["Stack Items To Bags"] = "Собрать вещи в сумки"
L["Stack Items To Bank"] = "Собрать вещи в банк"

-- Chat
L["Increases the amount of messages saved in a chat window, before they get replaced by new messages."] = "Увеличивает количество сообщений, сохраненных в окне чата, прежде чем они будут заменены новыми сообщениями."
L["Max Lines"] = "Максимальное колличество строк"
L["The max amount of messages kept in chat before they get replaced by new messages. Changing this setting will clear the chat in all windows."] = "Максимальное количество сообщений сохраняемых в чате, прежде чем они заменятся новыми сообщениями. Изменение этого параметра очистит чат во всех окнах."

-- Datatexts
L["Allows you to choose which text format the Bags datatext uses."] = "Позволяет выбрать формат текста сумок."
L["Bags Text Format"] = "Формат текста сумок"
L["Only Free Slots"] = "Только свободные слоты"
L["Only Used Slots"] = "Только занятые слоты"
L["Used/Total"] = "Занято/Всего"
L["Free/Total"] = "Свободно/Всего"

-- Minimap
L["Lowers the minimum allowed minimap size."] = "Снижает минимально допустимый размер миникарты."

-- Misc
L["Allows you to change template of the Raid Control button or hide it altogether."] = "Позволяет изменять вид кнопки управления рейдом или полностью скрыть её."
L["Attempts to remove borders on all ElvUI elements. This doesn't work on all statusbars, so some borders will be kept intact."] = "Удаляет границы на всех элементах ElvUI. Это работает не на всех статусбарах, поэтому некоторые границы останутся."
L["Hide Raid Control"] = "Скрыть управление рейдом"
L["Use Transparent Template"] = "Сделать фон прозрачным"

-- Unitframe
L["Allows you to position and change color and alpha of castbar text."] = "Позволяет перемещать и изменять цвет и прозрачность текста полос заклинаний."
L["Allows you to position the unitframe aura duration and stack text or hide it."] = "Позволяет перемещать или скрывать текст времени и стаков на аурах рамок юнитов."
L["Allows you to set a spacing between individual aura icons for the units you choose."] = "Позволяет устанавливать отступ между аурами на выбранных рамках юнитов."
L["Allows you to use a custom castbar backdrop color."] = "Позволяет использовать пользовательский цвет фона полосы заклинания"
L["Allows you to use a separate texture for unitframe power bars."] = "Позволяет использовать отдельную текстуру ресурса для рамок юнитов"
L["Assist"] = "Помощник"
L["Aura Spacing"] = "Отступ аур"
L["Boss"] = "Боссы"
L["Castbar Backdrop Color"] = "Цвет фона полосы заклинания"
L["Duration text will be hidden until it reaches this threshold (in seconds). Set to -1 to always show duration text."] = "Текс времени будет скрыт до тех пор, пока не достигнет указанного значения (в секундах). Установите -1, чтобы текст отображался всегда."
L["Duration Text"] = "Текст перезарядки"
L["Focus"] = "Фокус"
L["FocusTarget"] = "Цель фокуса"
L["Hide From Others"] = "Скрыть на чужих"
L["Hide Text On Units"] = "Скрыть текст на юнитах"
L["Hide Text"] = "Скрыть текст"
L["Horizontal offset of the duration text."] = "Отступ текста времени по горизонтали."
L["Horizontal offset of the stack count."] = "Отступ текста стаков по горизонтали."
L["Increases the maximum allowed vertical and horizontal spacing for party and raid frames."] = "Увеличивает максимально допустимое значение отступа по горизонтали и вертикали для рамок группы и рейда."
L["Invalid name, check spelling."] = "Неверное имя, проверьте орфографию"
L["Party"] = "Группа"
L["Pet"] = "Петомец"
L["PetTarget"] = "Цель петомца"
L["Player"] = "Игрок"
L["Position of the duration text on the aura icon."] = "Позиция текста времени на иконках аур."
L["Position of the stack count on the aura icon."] = "Позиция текста стаков на иконках аур."
L["PowerBar Texture"] = "Текстура ресурса"
L["Raid"] = "Рейд"
L["Raid40"] = "Рейд 40"
L["RaidPet"] = "Петомцы рейда"
L["Set Aura Spacing On Following Units"] = "Установить отступ аур для следующих юнитов:"
L["Sets space between individual aura icons."] = "Устанавливает отступ между отдельными иконками аур."
L["Stack Text"] = "Текст стаков"
L["Target"] = "Цель"
L["TargetTarget"] = "Цель цели"
L["TargetTargetTarget"] = "Цель цели цели"
L["Threshold"] = "Порог"
L["Vertical offset of the duration text."] = "Отступ текста времени по вертикали."
L["Vertical offset of the stack count."] = "Отступ текста стаков по вертикали."
L["Will hide duration text on auras that are not cast by you."] = "Скрывать текст времени на аурах наложенных не вами."
L["Will hide stack text on auras that are not cast by you."] = "Скрывать текст стаков на аурах наложенных не вами."