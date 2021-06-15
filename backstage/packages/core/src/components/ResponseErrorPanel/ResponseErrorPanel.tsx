/*
 * Copyright 2021 Spotify AB
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { ResponseError } from '@backstage/errors';
import {
  Divider,
  List,
  ListItem,
  ListItemText,
  makeStyles,
} from '@material-ui/core';
import React from 'react';
import { CodeSnippet } from '../CodeSnippet';
import { CopyTextButton } from '../CopyTextButton';
import { WarningPanel } from '../WarningPanel';

const useStyles = makeStyles(theme => ({
  text: {
    fontFamily: 'monospace',
    whiteSpace: 'pre',
    overflowX: 'auto',
    marginRight: theme.spacing(2),
  },
  divider: {
    margin: theme.spacing(2),
  },
}));

type Props = {
  error: Error;
};

/**
 * Renders details about a failed server request.
 *
 * Has special treatment for ResponseError errors, to display rich
 * server-provided information about what happened.
 */
export const ResponseErrorDetails = ({ error }: Props) => {
  const classes = useStyles();

  if (error.name !== 'ResponseError') {
    return (
      <List dense>
        <ListItemText primary="Message" secondary={error.message} />
      </List>
    );
  }

  const { data, cause } = error as ResponseError;
  const { request, response } = data;

  const errorString = `${response.statusCode}: ${cause.name}`;
  const requestString = request && `${request.method} ${request.url}`;
  const messageString = cause.message.replace(/\\n/g, '\n');
  const stackString = cause.stack?.replace(/\\n/g, '\n');
  const jsonString = JSON.stringify(data, undefined, 2);

  return (
    <List dense>
      <ListItem alignItems="flex-start">
        <ListItemText
          classes={{ secondary: classes.text }}
          primary="Error"
          secondary={errorString}
        />
        <CopyTextButton text={errorString} />
      </ListItem>
      <ListItem alignItems="flex-start">
        <ListItemText
          classes={{ secondary: classes.text }}
          primary="Message"
          secondary={messageString}
        />
        <CopyTextButton text={messageString} />
      </ListItem>
      {requestString && (
        <ListItem alignItems="flex-start">
          <ListItemText
            classes={{ secondary: classes.text }}
            primary="Request"
            secondary={requestString}
          />
          <CopyTextButton text={requestString} />
        </ListItem>
      )}
      {stackString && (
        <ListItem alignItems="flex-start">
          <ListItemText
            classes={{ secondary: classes.text }}
            primary="Stack Trace"
            secondary={stackString}
          />
          <CopyTextButton text={stackString} />
        </ListItem>
      )}
      <Divider component="li" className={classes.divider} />
      <ListItem alignItems="flex-start">
        <ListItemText
          classes={{ secondary: classes.text }}
          primary="Full Error as JSON"
          secondary={<CodeSnippet language="json" text={jsonString} />}
        />
        <CopyTextButton text={jsonString} />
      </ListItem>
    </List>
  );
};

/**
 * Renders a warning panel as the effect of a failed server request.
 *
 * Has special treatment for ResponseError errors, to display rich
 * server-provided information about what happened.
 */
export const ResponseErrorPanel = ({ error }: Props) => {
  return (
    <WarningPanel title={error.message}>
      <ResponseErrorDetails error={error} />
    </WarningPanel>
  );
};
