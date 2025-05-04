/// Types needed for using the library.
library;

import 'protocol_types/general_types.dart';
import 'protocol_types/server_to_client.dart';

/// Parent class for events sent by the server.
///
/// An empty sealed class, for use with switch statements.
sealed class ArchipelagoEvent {}

/// An update on the current information about the connected room.
class RoomUpdate extends ArchipelagoEvent {
  final RoomUpdateMessage update;

  RoomUpdate(this.update);
}

/// An event that describes items being sent to the client.
class ItemsReceived extends ArchipelagoEvent {
  /// The sent items.
  final List<SentItem> items;

  /// The number of items that have been received after receiving the items in this event.
  ///
  /// If this doesn't match the expected number, the client will need to resynchronize with the server.
  final int nextEmptySlot;

  ItemsReceived(this.items, this.nextEmptySlot);
}

/// An event describing locations that have been scouted.
class LocationsScouted extends ArchipelagoEvent {
  /// The list of items that have been scouted, with locations.
  ///
  /// [SentItem.player] refers to the receiving player here, rather than the sending player
  final List<SentItem> scouts;

  LocationsScouted(this.scouts);
}

/// An event containing a message to display to the user.
class DisplayMessage extends ArchipelagoEvent {
  /// The individual parts of the message.
  final List<MessagePart> parts;

  DisplayMessage(this.parts);
}

/// A message describing an item that has been sent.
class ItemSend extends DisplayMessage {
  /// The player is receiving the item.
  final Player receiving;

  /// The item that has been sent.
  final SentItem item;

  ItemSend(super.parts, this.receiving, this.item);
}

/// A message describing an item that has been found by cheat commands.
class ItemCheat extends DisplayMessage {
  /// The player is receiving the item.
  final Player receiving;

  /// The item that has been sent
  final SentItem item;

  ItemCheat(super.parts, this.receiving, this.item);
}

/// A message describing a hint that has been given.
class HintMessage extends DisplayMessage {
  /// The player who will receive the hinted item.
  final Player receiving;

  /// The item that has been hinted.
  final SentItem item;

  /// Whether or not the item has already been found.
  final bool found;

  HintMessage(super.parts, this.receiving, this.item, this.found);
}

/// A message describing a client connecting to the session.
class PlayerJoined extends DisplayMessage {
  /// The player who connected.
  final Player player;

  /// The tags of the client that connected.
  final List<String> tags;

  PlayerJoined(super.parts, this.player, this.tags);
}

/// A message describing a client disconnecting from the session.
class PlayerLeft extends DisplayMessage {
  /// The player who disconnected.
  final Player player;

  PlayerLeft(super.parts, this.player);
}

/// A message sent by a client to show to other players.
class ChatMessage extends DisplayMessage {
  /// The player who sent the message.
  final Player player;

  /// The message that was sent.
  final String message;

  ChatMessage(super.parts, this.player, this.message);
}

/// A message sent by the server to show to players.
class ServerChatMessage extends DisplayMessage {
  /// The message.
  final String message;

  ServerChatMessage(super.parts, this.message);
}

/// A message sent to a client for the purpose of tutorialization
class TutorialMessage extends DisplayMessage {
  TutorialMessage(super.parts);
}

/// A messsage describing the changes to a client's tags.
class TagsChanged extends DisplayMessage {
  /// The player using the client.
  final Player player;

  /// The new list of tags for the client.
  final List<String> tags;

  TagsChanged(super.parts, this.player, this.tags);
}

/// A message with the results of running a command.
class CommandResult extends DisplayMessage {
  CommandResult(super.parts);
}

/// A message with the results of running a command with admin privelages.
class AdminCommandResult extends DisplayMessage {
  AdminCommandResult(super.parts);
}

/// A message declaring that a player has achieved their goal.
class GoalReached extends DisplayMessage {
  /// The player who achieved their goal.
  final Player player;

  GoalReached(super.parts, this.player);
}

/// A message declaring that a player has released all their items.
class ItemsReleased extends DisplayMessage {
  /// The player releasing their items.
  final Player player;

  ItemsReleased(super.parts, this.player);
}

/// A message declaring that a player has requested to collect all their remaining items.
class ItemsCollected extends DisplayMessage {
  /// The player collecting their items.
  final Player player;

  ItemsCollected(super.parts, this.player);
}

/// A message with the current number of a countdown.
class CountdownMessage extends DisplayMessage {
  /// The countdown number.
  final int countdown;

  CountdownMessage(super.parts, this.countdown);
}

/// An event containing information sent from another client via the server.
class Bounced extends ArchipelagoEvent {
  /// The games this message was sent to.
  final List<String>? games;

  /// The players this message was sent to.
  final List<Player>? players;

  /// The tags that clients have that causes them to receive this message.
  final List<String>? tags;

  /// A key-value package of data.
  final Map<dynamic, dynamic>? data;

  Bounced({required this.data, this.games, this.players, this.tags});
}

/// An event responding to an invalid message from the client.
class InvalidPacket extends ArchipelagoEvent {
  /// The type of error.
  final String type;

  /// The command of the message that was invalid.
  final String? originalCommand;

  /// A description of the error.
  final String text;

  InvalidPacket(this.type, this.text, [this.originalCommand]);
}

/// An event contianing data retreived from the server data store.
class DataRetrieved extends ArchipelagoEvent {
  /// The data.
  final Map<String, dynamic> data;

  DataRetrieved(this.data);
}

/// An event replying to a request to set data in the server data store
class SetDataReply extends ArchipelagoEvent {
  /// The key that was set to.
  final String key;

  /// The new value of the key.
  final dynamic value;

  /// The original value of the key.
  final dynamic originalValue;

  /// The slot that sent the Set message causing this change.
  final int slot;

  SetDataReply(this.key, this.value, this.originalValue, this.slot);
}

/// A segment of a message to display to a server.
sealed class MessagePart {
  /// The text of the message.
  String get text;

  const MessagePart();
}

/// A segment of a message that is only text.
class TextMessagePart extends MessagePart {
  @override
  final String text;

  const TextMessagePart(this.text);
}

/// A segment of a message that is the name of a player.
class PlayerMessagePart extends MessagePart {
  /// The player whose name this is.
  final Player player;
  @override
  String get text => player.name;
  const PlayerMessagePart(this.player);
}

/// A segment of a message that is the name of an item.
class ItemMessagePart extends MessagePart {
  /// The item that this is the name of.
  final Item item;
  @override
  String get text => item.name;

  const ItemMessagePart(this.item);
}

/// A segment of a message that is the name of a location.
class LocationMessagePart extends MessagePart {
  /// The location that this is the name of.
  final Location location;
  @override
  String get text => location.name;

  const LocationMessagePart(this.location);
}

/// A segment of a message that is the name of an entrance.
class EntranceMessagePart extends MessagePart {
  /// The entrance that this is the name of.
  final Entrance entrance;
  @override
  String get text => entrance.name;

  const EntranceMessagePart(this.entrance);
}

// TODO: better description of this
/// A segment of a message that is the information about a hint.
class HintStatusPart extends MessagePart {
  @override
  final String text;

  /// The status of the hint.
  final HintStatus status;

  const HintStatusPart(this.text, this.status);
}

/// A segment of a message with a specific colour.
class ColorMessagePart extends MessagePart {
  @override
  final String text;

  /// The colour of the segment.
  final ConsoleColor color;

  const ColorMessagePart(this.text, this.color);
}

/// A player in the current session.
class Player {
  /// The current alias of the player.
  final String name;

  /// The slot number of the player.
  ///
  /// Can only be populated if the player is on the client's team.
  final int? id;

  const Player(this.name, [this.id]);
}

/// An item in the current session.
class Item {
  /// The name of the item.
  final String name;

  /// The id number of the item.
  final int id;

  /// Whether or not this item is considered a logical advancement.
  final bool logicalAdvancement;

  /// Whether or not this item is considered useful by the logic.
  final bool useful;

  /// Whether or not this item is a trap.
  final bool trap;

  const Item(
    this.name,
    this.id,
    this.logicalAdvancement,
    this.useful,
    this.trap,
  );
}

/// A location in the multiworld.
class Location {
  /// The name of the location.
  final String name;

  /// The id number of the location.
  final int id;

  const Location(this.name, this.id);
}

/// An entrance in the multiworld.
class Entrance {
  /// The name of the entrance.
  final String name;

  const Entrance(this.name);
}

// Corresponds to NetworkItem in the spec
/// An item sent to a player.
class SentItem {
  /// The location of the item.
  final Location location;

  /// The name of the item.
  final Item item;

  /// The player associated with this item.
  ///
  /// Normally this is the player whose world this is in.
  /// If this is in a [LocationsScouted] message, it is the player who will receive the item instead.
  final Player player;

  const SentItem(this.location, this.item, this.player);
}
